import { Expose, Transform, Type } from "class-transformer";
import { IsEnum } from "class-validator";
import { ObjectId } from "mongodb";
import { User } from "./user-model";
import { Mapper } from "../utils/mapper";
import { PostResponseDTO } from "./post-model";

export enum ReportStatus {
  ACTIVE = "ACTIVE",
  REJECTED = "REJECTED",
  ACCEPTED = "ACCEPTED",
  DELETED = "DELETED",
}

export class ReportModel {
  @Transform((value) => value.obj._id.toString())
  @Expose()
  _id?: ObjectId;

  @Expose()
  userId: string;

  @Expose()
  postId: string;

  @Expose()
  content?: string;

  @Expose()
  createdAt: Date;

  @Expose()
  @IsEnum(ReportStatus)
  status: ReportStatus;
}

export class ReportResponseDTO {
  @Expose()
  id: String;

  @Expose()
  userId: string;

  @Expose()
  postId: string;

  @Expose()
  content?: string;

  @Expose()
  createdAt: Date;

  @Expose()
  @IsEnum(ReportStatus)
  status: ReportStatus;

  @Expose()
  @Type(() => PostResponseDTO)
  post: PostResponseDTO;
}

export const mapToReportResponseDTO = (reportModel: ReportModel, postModel: PostResponseDTO): PostResponseDTO => {
  return Mapper.map(ReportResponseDTO, {
    ...reportModel,
    post: postModel,
    id: reportModel._id!.toString(),
  });
};
