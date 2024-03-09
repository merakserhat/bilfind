import { Expose } from "class-transformer";
import { JoinRoomData } from "./events/on_join_room";
import { SendMessageData } from "./events/on_send_message";

export interface SocketData {
  // ...
}

export interface ServerToClientEvents {
  log: (message: string) => void;
  message: (sendMessageData: SendMessageData) => void;
}

export interface InterServerEvents {
  // ...
}

export interface ClientToServerEvents {
  sendMessage: (data: SendMessageData) => void;
  joinRoom: (data: JoinRoomData) => void;
}
