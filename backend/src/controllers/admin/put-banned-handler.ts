import { Expose } from "class-transformer";
import { Request, Response } from "express";
import { Mapper } from "../../utils/mapper";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { IsEnum, IsString } from "class-validator";
import { User, UserStatus, mapToUserResponseDTO } from "../../models/user-model";
import { PostClient } from "../../clients/post-client";
import { PostResponseDTO, PostStatus, PostType, mapToPostResponseDTO } from "../../models/post-model";
import { UserClient } from "../../clients/user-client";
import { ReportClient } from "../../clients/report-client";
import { ReportStatus, mapToReportResponseDTO } from "../../models/report-model";
import { MailHelper } from "../../utils/mail-helper";

// base endpoint structure
const putAdminBanHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    // @ts-ignore
    const { userId } = req.params;

    console.log(userId);
    const user = await UserClient.getUserById(userId);

    if (!user) {
      return ApiHelper.getErrorResponseForCrash(res, "User could not be found");
    }

    if (user.latestStatus === UserStatus.BANNED) {
      const updateUser = await UserClient.updateStatus(user._id!.toString(), UserStatus.VERIFIED);
      if (!updateUser) {
        return ApiHelper.getErrorResponseForCrash(res, "User status could not be banned");
      }
    } else {
      const updateUser = await UserClient.updateStatus(user._id!.toString(), UserStatus.BANNED);
      if (!updateUser) {
        return ApiHelper.getErrorResponseForCrash(res, "User status could not be banned");
      }

      await PostClient.deleteUserPosts(user._id!.toString());
      await ReportClient.deleteUsersReports(user._id!.toString());
      await PostClient.deleteUserComments(user._id!.toString());

      if (user.mailSubscription) {
        // ban atılana mail gönder.
        MailHelper.sendBannedMail(user.email);
      }
    }

    const userGetDto = mapToUserResponseDTO(user);

    return ApiHelper.getSuccessfulResponse(res, { user: userGetDto });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default putAdminBanHandler;
