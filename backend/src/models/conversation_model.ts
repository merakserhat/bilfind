import { Expose, Transform, Type } from "class-transformer";
import { ObjectId } from "mongodb";
import { MessageModel } from "./message-model";
import { IsEnum } from "class-validator";
import { User, UserResponseDTO } from "./user-model";
import { PostResponseDTO } from "./post-model";
import { Mapper } from "../utils/mapper";
import { Departments } from "../utils/enums";

export enum ConversationStatus {
  WAITING = "WAITING",
  ACTIVE = "ACTIVE",
  DELETED = "DELETED",
}

export class ConversationModel {
  @Transform((value) => value.obj._id.toString())
  @Expose()
  _id?: ObjectId;

  @Expose()
  postId: string;

  @Expose()
  senderUserId: string;

  @Expose()
  postOwnerUserId: string;

  @Expose()
  createdAt: Date;

  @Expose()
  @IsEnum(ConversationStatus)
  status: ConversationStatus;

  @Expose()
  @Type(() => MessageModel)
  messages: MessageModel[];
}

export class ConversationResponseDto {
  @Transform((value) => value.obj._id.toString())
  @Expose()
  id: ObjectId;

  @Expose()
  post: PostResponseDTO;

  //owner info
  @Expose()
  ownerPhoto?: string;

  @Expose()
  ownerName: string;

  @Expose()
  ownerEmail: string;

  @Expose()
  ownerId: string;

  @Expose()
  ownerDepartment: Departments;

  //sender info
  @Expose()
  senderPhoto?: string;

  @Expose()
  senderName: string;

  @Expose()
  senderEmail: string;

  @Expose()
  senderId: string;

  @Expose()
  senderDepartment: Departments;

  @Expose()
  createdAt: Date;

  @Expose()
  @IsEnum(ConversationStatus)
  status: ConversationStatus;

  @Expose()
  @Type(() => MessageModel)
  messages: MessageModel[];
}

export const mapToConversationResponseDTO = (
  conversation: ConversationModel,
  post: PostResponseDTO,
  senderUser: User,
  postOwnerUser: User
): ConversationResponseDto => {
  return Mapper.map(ConversationResponseDto, {
    ...conversation,
    id: conversation._id!.toString(),
    post,
    //post owner
    ownerPhoto: postOwnerUser.profilePhoto,
    ownerName: postOwnerUser.name + " " + postOwnerUser.familyName,
    ownerDepartment: postOwnerUser.departmant,
    ownerEmail: postOwnerUser.email,
    ownerId: postOwnerUser._id!.toString(),
    //sender
    senderPhoto: senderUser.profilePhoto,
    senderName: senderUser.name + " " + senderUser.familyName,
    senderDepartment: senderUser.departmant,
    senderEmail: senderUser.email,
    senderId: senderUser._id!.toString(),
  });
};
