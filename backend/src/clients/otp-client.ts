import mongoose from "mongoose";
import { Mapper } from "../utils/mapper";
import Logging from "../utils/logging";
import { Otp, OtpType } from "../models/otp-model";

export class OtpClient {
  public static getOtpCode(): number {
    const code = Math.floor(100000 + Math.random() * 900000);
    return code;
  }

  static async createRegisterOtp(email: string, otpType: OtpType): Promise<Otp | null> {
    try {
      const db = mongoose.connection.db;
      const userCollection = db.collection("otp");

      const currentDate = new Date();
      const threeMinutesLater = new Date(currentDate.getTime() + 3 * 60000);

      const otp: Otp = {
        code: this.getOtpCode(),
        createdAt: currentDate,
        validUntil: threeMinutesLater,
        email,
        type: otpType,
      };

      const data = await userCollection.insertOne(otp);

      Logging.info("Otp code is generated, ", otp);

      return otp;
    } catch (error) {
      Logging.error(error);
      return null;
    }
  }

  static async verifyRegistirationOtp(email: string, otpCode: number, otpType: OtpType): Promise<boolean> {
    try {
      const db = mongoose.connection.db;
      const otpCollection = db.collection("otp");

      const data = await otpCollection.findOne({ email, type: otpType }, { sort: { createdAt: -1 } });
      const otp: Otp = Mapper.map(Otp, data);

      if (!otp) {
        return false;
      }

      const currentDate: Date = new Date();

      if (currentDate.getTime() > otp.validUntil.getTime()) {
        Logging.info("Given otp code is out date.");
        return false;
      }

      if (otpCode !== otp.code) {
        Logging.info("Given otp code is not valid!", otpCode);
        return false;
      }

      return true;
    } catch (error) {
      Logging.error(error);
      return false;
    }
  }
}
