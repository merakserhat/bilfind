import { Expose, Transform } from "class-transformer";
import { ObjectId } from "mongodb";

export class Otp {
  @Transform((value) => value.obj._id.toString())
  @Expose()
  _id?: ObjectId;

  @Expose()
  email: string;

  @Expose()
  createdAt: Date;

  @Expose()
  validUntil: Date;

  @Expose()
  code: number;

  @Expose()
  type: OtpType;
}

export enum OtpType {
  REGISTER,
  RESET,
}
