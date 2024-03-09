import { Expose } from "class-transformer";
import { Request, Response } from "express";
import { Mapper } from "../../utils/mapper";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { ApiErrorCode } from "../../utils/error-codes";
import { UserClient } from "../../clients/user-client";
import { HashingHelper } from "../../utils/hashing-helper";
import { IsString, validate } from "class-validator";
import { generateAuthenticationToken } from "../../utils/authentication-helper";
import { User, mapToUserResponseDTO } from "../../models/user-model";

class ChangePasswordRequest {
  @Expose()
  @IsString()
  oldPassword: string;

  @Expose()
  @IsString()
  newPassword: string;
}

// base endpoint structure
const changePasswordHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.query)));
  try {
    const changePasswordRequest: ChangePasswordRequest = Mapper.map(ChangePasswordRequest, req.body);

    // @ts-ignore
    const locals = req.locals;
    const user: User = locals.user;

    const isPasswordValid = HashingHelper.comparePassword(changePasswordRequest.oldPassword, user.hashedPassword);

    if (!isPasswordValid) {
      return ApiHelper.getErrorResponse(res, 403, [
        {
          errorCode: ApiErrorCode.WRONG_PASSWORD,
          message: "Password is not valid.",
        },
      ]);
    }

    const hashedPassword = HashingHelper.hashPassword(changePasswordRequest.newPassword);

    const updated = await UserClient.changePassword(user._id!.toString(), hashedPassword);

    if (!updated) {
      return ApiHelper.getErrorResponseForCrash(res, "Something went wrong while updating password");
    }

    user.hashedPassword = hashedPassword;
    const token = generateAuthenticationToken(user);

    if (!token) {
      return ApiHelper.getErrorResponseForCrash(res, "Authentication token could not be generated");
    }

    ApiHelper.getSuccessfulResponse(res, { message: "User password successfully updated", token });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default changePasswordHandler;
