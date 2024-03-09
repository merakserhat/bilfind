import { Request, Response } from "express";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { PostClient } from "../../clients/post-client";
import { UserClient } from "../../clients/user-client";
import { User, mapToUserResponseDTO } from "../../models/user-model";
import { mapToCommentResponseDTO } from "../../models/comment-model";
import { mapToPostResponseDTO } from "../../models/post-model";

// base endpoint structure
const getPostDetailHandler = async (req: Request, res: Response) => {
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

    const comments = await PostClient.getPostComments(post._id!.toString());
    const commentOwnerIdList = comments.map((comment) => comment.userId);
    const users = await UserClient.getUsersByListId(commentOwnerIdList);
    const userMap: Record<string, User> = {};
    users.forEach((user) => (userMap[user._id!.toString()] = user));

    const getCommentDTOList = comments.map((comment) => mapToCommentResponseDTO(comment, userMap[comment.userId]));

    const owner = await UserClient.getUserById(post.userId);
    const ownerResponseDTO = mapToUserResponseDTO(owner!);
    const postResponseDTO = mapToPostResponseDTO(post, owner!);
    return ApiHelper.getSuccessfulResponse(res, {
      post: postResponseDTO,
      comments: getCommentDTOList,
      owner: ownerResponseDTO,
    });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default getPostDetailHandler;
