import { Expose, Transform } from "class-transformer";
import { ObjectId } from "mongodb";
import { User } from "./user-model";
import { Mapper } from "../utils/mapper";
import { Departments } from "../utils/enums";

export class CommentModel {
  @Transform((value) => value.obj._id.toString())
  @Expose()
  _id?: ObjectId;

  @Expose()
  postId: string;

  @Expose()
  userId: string;

  @Expose()
  parentId?: string;

  @Expose()
  content: string;

  @Expose()
  createdAt: Date;

  @Expose()
  isDeleted: boolean;
}

export class CommentResponseDTO {
  @Expose()
  id: String;

  @Expose()
  postId: string;

  @Expose()
  userId: string;

  @Expose()
  parentId?: string;

  @Expose()
  content: string;

  @Expose()
  createdAt: Date;

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
}

export const mapToCommentResponseDTO = (commentModel: CommentModel, user: User): CommentResponseDTO => {
  return Mapper.map(CommentResponseDTO, {
    ...commentModel,
    id: commentModel._id!.toString(),
    ownerPhoto: user.profilePhoto,
    ownerName: user.name + " " + user.familyName,
    ownerDepartment: user.departmant,
    ownerEmail: user.email,
    ownerId: user._id!.toString(),
  });
};
