import { Expose } from "class-transformer";
import { Request, Response } from "express";
import { Mapper } from "../../utils/mapper";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { ApiErrorCode } from "../../utils/error-codes";
import { UserClient } from "../../clients/user-client";
import { HashingHelper } from "../../utils/hashing-helper";
import { IsEnum, IsString } from "class-validator";
import { MailHelper } from "../../utils/mail-helper";
import { OtpClient } from "../../clients/otp-client";
import { OtpType } from "../../models/otp-model";
import { Departments } from "../../utils/enums";
import { UserStatus } from "../../models/user-model";

class PostRegisterRequest {
  @Expose()
  @IsString()
  email: string;

  @Expose()
  @IsString()
  password: string;

  @Expose()
  @IsString()
  name: string;

  @Expose()
  @IsString()
  familyName: string;

  @Expose()
  @IsEnum(Departments)
  department: Departments;
}

// base endpoint structure
const postRegister = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.query)));
  try {
    const getTestRequest: PostRegisterRequest = Mapper.map(PostRegisterRequest, req.body);

    const existingUser = await UserClient.getUserByEmail(getTestRequest.email);

    if (existingUser?.latestStatus === UserStatus.WAITING) {
      UserClient.deleteUserByEmail(existingUser.email);
    } else if (existingUser) {
      return ApiHelper.getErrorResponse(res, 403, [
        {
          errorCode: ApiErrorCode.EMAIL_ALREADY_EXISTS,
          message: "Email already exists",
        },
      ]);
    }

    const hashedPassword = HashingHelper.hashPassword(getTestRequest.password);

    const userId = await UserClient.createUser(
      getTestRequest.email,
      hashedPassword,
      getTestRequest.name,
      getTestRequest.familyName,
      getTestRequest.department
    );
    if (!userId) {
      return ApiHelper.getErrorResponse(res, 500, [
        {
          errorCode: ApiErrorCode.SOMETHING_BAD_HAPPENED,
          message: "User could not be created",
        },
      ]);
    }

    const user = await UserClient.getUserById(userId.toString());

    //TODO: you can map to return user instead of doing this
    user!.hashedPassword = "";

    const otp = await OtpClient.createRegisterOtp(user!.email, OtpType.REGISTER);
    MailHelper.sendRegisterOtpMail(otp!);
    ApiHelper.getSuccessfulResponse(res, { message: "User successfully registered", user });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default postRegister;
