import { Expose, Transform } from "class-transformer";
import { ObjectId } from "mongodb";
import { LocationModel } from "./location-model";

export class MessageModel {
  @Expose()
  conversationId: string;

  @Expose()
  senderId: string;

  @Expose()
  createdAt: Date;

  @Expose()
  text?: string;

  @Expose()
  imageSrc?: string;

  @Expose()
  location?: LocationModel;

  @Expose()
  messageType: MessageType;
}

export enum MessageType {
  TEXT = "TEXT",
  IMAGE = "IMAGE",
  LOCATION = "LOCATION",
}
