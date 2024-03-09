import { Expose, Transform } from "class-transformer";
import { ObjectId } from "mongodb";

export class LocationModel {
  @Transform((value) => value.obj._id.toString())
  @Expose()
  _id?: ObjectId;

  @Expose()
  lat: number;

  @Expose()
  long: number;

  @Expose()
  createdAt: string;
}
