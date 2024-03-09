import { Expose } from "class-transformer";
import { Request, Response } from "express";
import { Mapper } from "../../utils/mapper";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { IsEnum, IsString } from "class-validator";
import { User } from "../../models/user-model";
import { PostClient } from "../../clients/post-client";
import { PostType } from "../../models/post-model";
import { UserClient } from "../../clients/user-client";

// base endpoint structure
const putUserFavHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    const { postId } = req.query;

    console.log(postId);
    if (!postId || typeof postId !== "string") {
      return ApiHelper.getErrorResponseForCrash(res, "Post Id must be given");
    }

    // @ts-ignore
    const locals = req.locals;
    const user: User = locals.user;

    const post = await PostClient.getPostById(postId);
    console.log(post);

    if (!post) {
      return ApiHelper.getErrorResponseForCrash(res, "Post could not be created");
    }

    if (user.favoritePostIds.includes(postId)) {
      const result = await UserClient.userDeleteFavorite(user._id!.toString(), postId);

      if (!result) {
        return ApiHelper.getErrorResponseForCrash(res, "Something went wrong while updating user favorites");
      }

      PostClient.updateFavCount(postId, post.favCount - 1);
      return ApiHelper.getSuccessfulResponse(res);
    }

    const result = await UserClient.userPutFavorite(user._id!.toString(), postId);
    if (!result) {
      return ApiHelper.getErrorResponseForCrash(res, "Something went wrong while updating user favorites");
    }

    PostClient.updateFavCount(postId, post.favCount + 1);
    return ApiHelper.getSuccessfulResponse(res);
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default putUserFavHandler;
