import { Expose } from "class-transformer";
import { Request, Response } from "express";
import { Mapper } from "../../utils/mapper";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { IsEnum, IsString } from "class-validator";
import { User } from "../../models/user-model";
import { PostClient } from "../../clients/post-client";
import { PostType } from "../../models/post-model";
import { MailHelper } from "../../utils/mail-helper";
import { UserClient } from "../../clients/user-client";

export class PostCommentRequest {
  @Expose()
  @IsString()
  postId: string;

  @Expose()
  parentId?: string;

  @Expose()
  @IsString()
  content: string;
}

// base endpoint structure
const postCommentHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    const postCommentRequest: PostCommentRequest = Mapper.map(PostCommentRequest, req.body);

    // @ts-ignore
    const locals = req.locals;
    const user: User = locals.user;

    const post = await PostClient.getPostById(postCommentRequest.postId);

    if (!post) {
      return ApiHelper.getErrorResponseForCrash(res, "Post could not be created");
    }
    const postOwner = await UserClient.getUserById(post.userId);

    if (!postOwner) {
      return ApiHelper.getErrorResponseForCrash(res, "Post Owner not found.");
    }

    if (postCommentRequest.parentId) {
      const comment = await PostClient.getCommentById(postCommentRequest.parentId);

      if (!comment) {
        return ApiHelper.getErrorResponseForCrash(
          res,
          "Parent comment not found with id " + postCommentRequest.parentId
        );
      }
    }

    const createdCommentId = await PostClient.createComment(postCommentRequest, user);

    if (!createdCommentId) {
      return ApiHelper.getErrorResponseForCrash(res, "Comment could not be created");
    }

    const comment = await PostClient.getCommentById(createdCommentId.toString());

    if (!comment) {
      return ApiHelper.getErrorResponseForCrash(res, "Comment could not be created");
    }

    if (postOwner.mailSubscription) {
      //todo
      MailHelper.sendMailCommentedPostOwner(postOwner.email, user.name, post.title, comment.content.toString());
    }

    if (postCommentRequest.parentId) {
      const parentComment = await PostClient.getCommentById(postCommentRequest.parentId);
      if (!parentComment) {
        return ApiHelper.getErrorResponseForCrash(
          res,
          "Parent comment not found with id " + postCommentRequest.parentId
        );
      }
      const commentOwner = await UserClient.getUserById(parentComment.userId);
      if (!commentOwner) {
        return ApiHelper.getErrorResponseForCrash(res, "Comment Owner not found.");
      }

      if (commentOwner.mailSubscription) {
        //todo
        MailHelper.sendMailRepliedCommentOwner(
          commentOwner.email,
          commentOwner.name,
          parentComment.content.toString(),
          comment.content.toString(),
          postOwner.name,
          post.title
        );
      }
    }

    return ApiHelper.getSuccessfulResponse(res, comment);
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default postCommentHandler;
