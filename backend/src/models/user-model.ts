import { Expose, Transform } from "class-transformer";
import { ObjectId } from "mongodb";
import { Mapper } from "../utils/mapper";
import { Departments } from "../utils/enums";

export class User {
  @Transform((value) => value.obj._id.toString())
  @Expose()
  _id?: ObjectId;

  @Expose()
  email: string;

  @Expose()
  hashedPassword: string;

  @Expose()
  name: string;

  @Expose()
  createdAt: Date;

  @Expose()
  profilePhoto?: string;

  @Expose()
  familyName: string;

  @Expose()
  departmant: Departments;

  @Expose()
  latestStatus: UserStatus;

  @Expose()
  favoritePostIds: string[];

  @Expose()
  ownPostIds: string[];

  @Expose()
  ownReportIds: string[];

  @Expose()
  isAdmin: boolean;

  @Expose()
  mailSubscription: boolean;
}

export class UserResponseDTO {
  @Expose()
  id: String;

  @Expose()
  email: string;

  @Expose()
  name: string;

  @Expose()
  profilePhoto?: string;

  @Expose()
  familyName: string;

  @Expose()
  createdAt: Date;

  @Expose()
  departmant: Departments;

  @Expose()
  latestStatus: UserStatus;

  @Expose()
  favoritePostIds: string[];

  @Expose()
  ownPostIds: string[];

  @Expose()
  ownReportIds: string[];

  @Expose()
  isAdmin: boolean;

  @Expose()
  mailSubscription: boolean;
}

export const mapToUserResponseDTO = (user: User): UserResponseDTO => {
  return Mapper.map(UserResponseDTO, {
    ...user,
    id: user._id!.toString(),
  });
};

export enum UserStatus {
  WAITING = "WAITING",
  VERIFIED = "VERIFIED",
  BANNED = "BANNED",
  DELETED = "DELETED",
}
