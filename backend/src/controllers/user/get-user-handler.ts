import { Request, Response } from "express";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { PostClient } from "../../clients/post-client";
import { UserClient } from "../../clients/user-client";
import { User, mapToUserResponseDTO } from "../../models/user-model";
import { mapToCommentResponseDTO } from "../../models/comment-model";
import { mapToPostResponseDTO } from "../../models/post-model";

// base endpoint structure
const getUserHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    // @ts-ignore
    const locals = req.locals;
    const requestedUser: User = locals.user;

    const { userId } = req.query;

    if (!userId || typeof userId !== "string") {
      return ApiHelper.getErrorResponseForCrash(res, "User Id must be given");
    }

    const user = await UserClient.getUserById(userId);

    if (!user) {
      return ApiHelper.getErrorResponseForCrash(res, "Post could not be found");
    }

    const userDTO = mapToUserResponseDTO(user);

    if (requestedUser._id!.toString() !== user._id!.toString()) {
      userDTO.favoritePostIds = [];
    }

    return ApiHelper.getSuccessfulResponse(res, {
      user: userDTO,
    });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default getUserHandler;
