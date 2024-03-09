import { Request, Response } from "express";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { ApiErrorCode } from "../../utils/error-codes";
import { UserClient } from "../../clients/user-client";
import { OtpClient } from "../../clients/otp-client";
import { OtpType } from "../../models/otp-model";
import { MailHelper } from "../../utils/mail-helper";

// base endpoint structure
const getResetPasswordCode = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.query)));
  try {
    const { email } = req.query;

    if (typeof email !== "string") {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }

    const user = await UserClient.getUserByEmail(email);
    if (!user) {
      return ApiHelper.getErrorResponse(res, 403, [
        {
          errorCode: ApiErrorCode.EMAIL_DOES_NOT_EXISTS,
          message: "Email does not exists",
        },
      ]);
    }

    const otp = await OtpClient.createRegisterOtp(user!.email, OtpType.RESET);
    MailHelper.sendResetOtpMail(otp!);
    ApiHelper.getSuccessfulResponse(res, { message: "Reset password otp sent successfully!" });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default getResetPasswordCode;