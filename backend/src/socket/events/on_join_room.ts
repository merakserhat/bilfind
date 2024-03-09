import { Expose } from "class-transformer";
import { Socket } from "socket.io";
import { sendLog } from "./client_send_log";

export class JoinRoomData {
  @Expose()
  conversationId: string;

  @Expose()
  userId: string;
}

export const joinRoom = async (data: JoinRoomData, socket: Socket) => {
  sendLog(`${data.userId} joined room: ${data.conversationId}`, socket);
  socket.join(data.conversationId);
  sendLog(`${data.userId} connected to your room!`, socket, data.conversationId);
};
