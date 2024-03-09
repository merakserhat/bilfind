import { Expose } from "class-transformer";
import { Request, Response } from "express";
import { Mapper } from "../../utils/mapper";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { User } from "../../models/user-model";
import { PostClient } from "../../clients/post-client";
import { ReportClient } from "../../clients/report-client";
import { mapToPostResponseDTO } from "../../models/post-model";
import { mapToReportResponseDTO } from "../../models/report-model";
import { UserClient } from "../../clients/user-client";

// base endpoint structure
const postReportPostHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    // @ts-ignore
    const locals = req.locals;
    const user: User = locals.user;
    const userId = user._id!.toString();
    const { postId } = req.params;
    const { content } = req.query;

    if (content && typeof content !== "string") {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }

    const post = await PostClient.getPostById(postId);

    if (!post) {
      return ApiHelper.getErrorResponseForCrash(res, "Reported Post Does not Exist.");
    }

    const createdReportId = await ReportClient.createReport(user._id!.toString(), postId, content);

    if (!createdReportId) {
      return ApiHelper.getErrorResponseForCrash(res, "Report could not be created.");
    }

    const report = await ReportClient.getReportById(createdReportId.toString());

    if (!report) {
      return ApiHelper.getErrorResponseForCrash(res, "Report could not be created.");
    }

    const userUpdated = await UserClient.userPutReport(userId, report._id!.toString());

    if (!userUpdated) {
      return ApiHelper.getErrorResponseForCrash(res, "Report could not be added to users own posts");
    }

    const getPostDTO = mapToPostResponseDTO(post, user);

    const getReportDTO = mapToReportResponseDTO(report, getPostDTO);

    return ApiHelper.getSuccessfulResponse(res, { report: getReportDTO });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default postReportPostHandler;
