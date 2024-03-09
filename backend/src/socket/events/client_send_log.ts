import { Socket } from "socket.io";
import Logging from "../../utils/logging";

export const sendLog = (message: string, socket: Socket, to?: string) => {
  if (!to) {
    socket.emit("log", message);
    Logging.info(message);
  } else {
    socket.to(to!).emit("log", message);
    Logging.info(message, "broadcasted");
  }
};
