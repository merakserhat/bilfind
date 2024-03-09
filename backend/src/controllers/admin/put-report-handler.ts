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
const putAdminReportHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    // @ts-ignore
    const { reportId } = req.params;
    const { status } = req.params;

    const report = await ReportClient.getReportById(reportId);

    if (!report) {
      return ApiHelper.getErrorResponseForCrash(res, "Report could not be found");
    }

    const requestedUser = await UserClient.getUserById(report.userId);

    const postId = report.postId;

    const post = await PostClient.getPostById(postId);

    if (!post) {
      return ApiHelper.getErrorResponseForCrash(res, "Report status could not be updated");
    }

    const user = await UserClient.getUserById(post.userId);

    if (!user) {
      return ApiHelper.getErrorResponseForCrash(res, "Report status could not be updated");
    }

    const updatedReport = await ReportClient.updateReportStatus(reportId, postId, status);

    if (!updatedReport) {
      return ApiHelper.getErrorResponseForCrash(res, "Report status could not be updated");
    }

    if (requestedUser!.mailSubscription) {
      // reportu atana mail gönder.
      MailHelper.sendReportStatusUpdateMail(requestedUser!.email, user.name, status);
    }

    if (status === ReportStatus.ACCEPTED) {
      const updatedPost = await PostClient.updatePostStatus(postId, PostStatus.BANNED);
      if (!updatedPost) {
        return ApiHelper.getErrorResponseForCrash(res, "Post status could not be updated");
      }

      if (user.mailSubscription) {
        // rapor kabul edildiyse psotu atana psotunun kaldırıldığıan dair mail gonder.
        MailHelper.sendReportStatusUpdateMailtoPostOwner(user.email, post.title);
      }
      //UserClient.updateStatus(user.email, UserStatus.BANNED)
    }

    const postDTOMap = mapToPostResponseDTO(post, user);

    const reportsDTOMap = mapToReportResponseDTO(report, postDTOMap);

    return ApiHelper.getSuccessfulResponse(res, { report: reportsDTOMap });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default putAdminReportHandler;
