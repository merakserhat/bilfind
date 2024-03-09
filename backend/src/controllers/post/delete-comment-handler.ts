import { Request, Response } from "express";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { PostClient } from "../../clients/post-client";
import { UserClient } from "../../clients/user-client";
import { User } from "../../models/user-model";
import { mapToCommentResponseDTO } from "../../models/comment-model";

// base endpoint structure
const deleteCommentHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    const { commentId } = req.query;

    if (!commentId || typeof commentId !== "string") {
      return ApiHelper.getErrorResponseForCrash(res, "Comment Id must be given");
    }

    const comment = await PostClient.getCommentById(commentId);

    if (!comment) {
      return ApiHelper.getErrorResponseForCrash(res, "Comment could not be found");
    }

    // @ts-ignore
    const locals = req.locals;
    const user: User = locals.user;
    const userId = user._id!.toString();

    if (userId !== comment.userId) {
      return ApiHelper.getErrorResponseForCrash(res, "Comment does not belong to this user");
    }

    const isDeleted = await PostClient.deleteComment(comment._id!.toString());

    if (!isDeleted) {
      return ApiHelper.getErrorResponseForCrash(res, "Comment could not be deleted");
    }

    return ApiHelper.getSuccessfulResponse(res);
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default deleteCommentHandler;
