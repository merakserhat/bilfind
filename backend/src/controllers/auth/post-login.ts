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
import { UserStatus, mapToUserResponseDTO } from "../../models/user-model";

class PostLoginRequest {
  @Expose()
  @IsString()
  email: string;

  @Expose()
  @IsString()
  password: string;
}

// base endpoint structure
const postLogin = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.body, Object.getOwnPropertyNames(req.body)));
  try {
    const postLoginRequest: PostLoginRequest = Mapper.map(PostLoginRequest, req.body);

    if (!postLoginRequest.email.endsWith("bilkent.edu.tr")) {
      postLoginRequest.email += "@ug.bilkent.edu.tr";
    }

    const user = await UserClient.getUserByEmail(postLoginRequest.email);
    if (!user) {
      return ApiHelper.getErrorResponse(res, 403, [
        {
          errorCode: ApiErrorCode.EMAIL_DOES_NOT_EXISTS,
          message: "Email does not exist",
        },
      ]);
    }

    if (user.latestStatus === UserStatus.WAITING) {
      UserClient.deleteUserByEmail(postLoginRequest.email);
      return ApiHelper.getErrorResponse(res, 401, [
        {
          errorCode: ApiErrorCode.EMAIL_DOES_NOT_EXISTS,
          message: "Incomplete registration",
        },
      ]);
    }

    if (user.latestStatus === UserStatus.BANNED) {
      return ApiHelper.getErrorResponse(res, 401, [
        {
          errorCode: ApiErrorCode.BANNED,
          message: "User has been Banned.",
        },
      ]);
    }

    const isPasswordValid = HashingHelper.comparePassword(postLoginRequest.password, user.hashedPassword);

    if (!isPasswordValid) {
      return ApiHelper.getErrorResponse(res, 403, [
        {
          errorCode: ApiErrorCode.WRONG_PASSWORD,
          message: "Password is not valid.",
        },
      ]);
    }
    const token = generateAuthenticationToken(user);

    if (!token) {
      return ApiHelper.getErrorResponseForCrash(res, "Authentication token could not be generated");
    }

    const userResponseDTO = mapToUserResponseDTO(user);
    ApiHelper.getSuccessfulResponse(res, {
      message: "User successfully logged in",
      user: userResponseDTO,
      token,
    });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default postLogin;
