import { Request, Response } from "express";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { User } from "../../models/user-model";
import { PostClient } from "../../clients/post-client";
import { PostModel, PostType, mapToPostResponseDTO } from "../../models/post-model";
import { UserClient } from "../../clients/user-client";

// base endpoint structure
const getUserPostsHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    // @ts-ignore
    const locals = req.locals;
    const user: User = locals.user;

    const { userId } = req.query;

    let retrievedUser: User | null = null;
    if (typeof userId == "string") {
      retrievedUser = await UserClient.getUserById(userId);
    }

    if (userId && !retrievedUser) {
      return ApiHelper.getErrorResponseForCrash(res, "User could not be found");
    }

    let favoritePosts: PostModel[] = [];
    if (!retrievedUser) {
      favoritePosts = await PostClient.getPostsByIdList(user.favoritePostIds);
    }
    const userPosts: PostModel[] = await PostClient.getPostsByUserId(
      retrievedUser?._id?.toString() ?? user._id!.toString()
    );

    const postOwnerIdList = [...favoritePosts, ...userPosts].map((post) => post.userId);
    const users = await UserClient.getUsersByListId(postOwnerIdList);
    const userMap: Record<string, User> = {};
    users.forEach((user) => (userMap[user._id!.toString()] = user));

    const favoritePostDTOList = favoritePosts.map((post) => mapToPostResponseDTO(post, userMap[post.userId]));
    const userPostDTOList = userPosts.map((post) => mapToPostResponseDTO(post, userMap[post.userId]));

    return ApiHelper.getSuccessfulResponse(res, { userPosts: userPostDTOList, favoritePosts: favoritePostDTOList });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default getUserPostsHandler;
