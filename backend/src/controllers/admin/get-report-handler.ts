import { Request, Response } from "express";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { User } from "../../models/user-model";
import { PostClient } from "../../clients/post-client";
import { PostModel, PostResponseDTO, PostType, mapToPostResponseDTO } from "../../models/post-model";
import { UserClient } from "../../clients/user-client";
import { ReportModel, mapToReportResponseDTO } from "../../models/report-model";
import { ReportClient } from "../../clients/report-client";
import { report } from "process";

// base endpoint structure
const getReportHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    const reports: ReportModel[] = await ReportClient.getReports();

    const postIdList = [...reports].map((report) => report.postId);
    const posts = await PostClient.getReportedPost(postIdList);
    const postMap: Record<string, PostModel> = {};
    posts.forEach((post) => (postMap[post._id!.toString()] = post));

    const postOwnerIdList = [...posts].map((post) => post.userId);
    const users = await UserClient.getUsersByListId(postOwnerIdList);
    const userMap: Record<string, User> = {};
    users.forEach((user) => (userMap[user._id!.toString()] = user));

    const postDTOMap: Record<string, PostResponseDTO> = {};
    posts.forEach((post) => (postDTOMap[post._id!.toString()] = mapToPostResponseDTO(post, userMap[post.userId])));

    const reportsDTOList = reports.map((report) => mapToReportResponseDTO(report, postDTOMap[report.postId]));

    return ApiHelper.getSuccessfulResponse(res, { reports: reportsDTOList });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default getReportHandler;
