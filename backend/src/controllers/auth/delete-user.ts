import { Expose } from "class-transformer";
import { Request, Response } from "express";
import { Mapper } from "../../utils/mapper";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { ApiErrorCode } from "../../utils/error-codes";
import { UserClient } from "../../clients/user-client";
import { IsNumber, IsString, validate } from "class-validator";
import { OtpClient } from "../../clients/otp-client";
import { UserStatus } from "../../models/user-model";
import { PostClient } from "../../clients/post-client";
import { ReportClient } from "../../clients/report-client";

class DeleteUserRequest {
  @Expose()
  @IsString()
  email: string;
}

// base endpoint structure
const deleteUser = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.query)));
  try {
    const deleteUserRequest: DeleteUserRequest = Mapper.map(DeleteUserRequest, req.query);

    const user = await UserClient.getUserByEmail(deleteUserRequest.email);
    if (!user) {
      return ApiHelper.getErrorResponse(res, 403, [
        {
          errorCode: ApiErrorCode.EMAIL_DOES_NOT_EXISTS,
          message: "Email does not exists",
        },
      ]);
    }

    const deleteResult = await UserClient.deleteUserByEmail(user.email);

    if (!deleteResult) {
      return ApiHelper.getErrorResponseForCrash(res, "User could not be deleted");
    }

    // delete user posts
    await PostClient.deleteUserPosts(user._id!.toString());

    // delete user conversations

    // delete user reports
    await ReportClient.deleteUsersReports(user._id!.toString());

    // delete comments under deleted comments
    // ? if we do delete them this way, it will be hard to determine whether
    // user deleted it deliberately or it is deleted as a result of parent deletion.

    // delete user comments
    await PostClient.deleteUserComments(user._id!.toString());

    return ApiHelper.getSuccessfulResponse(res, { message: "User successfully deleted" });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default deleteUser;
