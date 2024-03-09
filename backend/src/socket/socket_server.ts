import { Namespace, Server, Socket } from "socket.io";
import * as http from "http";
import { ClientToServerEvents, InterServerEvents, ServerToClientEvents, SocketData } from "./socket_event_interfaces";
import { joinRoom } from "./events/on_join_room";
import { sendMessage } from "./events/on_send_message";
import { sendLog } from "./events/client_send_log";

export class SocketServer {
  connect(server: http.Server) {
    const io = new Server<ClientToServerEvents, ServerToClientEvents, InterServerEvents, SocketData>(server);

    const nameSpace: Namespace<ClientToServerEvents, ServerToClientEvents, InterServerEvents, SocketData> =
      io.of("/messaging");

    nameSpace.on("connection", (socket) => {
      sendLog(`Connected to server with id ${socket.id}`, socket);

      socket.on("joinRoom", async (data) => await joinRoom(data, socket));

      socket.on("sendMessage", async (data) => await sendMessage(data, socket));
    });
  }
}
