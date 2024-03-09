import { Request, Response } from "express";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { PostClient } from "../../clients/post-client";
import { UserClient } from "../../clients/user-client";
import { User } from "../../models/user-model";
import { mapToCommentResponseDTO } from "../../models/comment-model";
import { PostStatus } from "../../models/post-model";

// base endpoint structure
const deletePostHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    const { postId } = req.query;

    if (!postId || typeof postId !== "string") {
      return ApiHelper.getErrorResponseForCrash(res, "Post Id must be given");
    }

    const post = await PostClient.getPostById(postId);

    if (!post) {
      return ApiHelper.getErrorResponseForCrash(res, "Post could not be found");
    }

    // @ts-ignore
    const locals = req.locals;
    const user: User = locals.user;
    const userId = user._id!.toString();

    if (userId !== post.userId) {
      return ApiHelper.getErrorResponseForCrash(res, "Post does not belong to this user");
    }

    const isDeleted = await PostClient.updatePostStatus(post._id!.toString(), PostStatus.DELETED);

    if (!isDeleted) {
      return ApiHelper.getErrorResponseForCrash(res, "Post could not be deleted");
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

export default deletePostHandler;
