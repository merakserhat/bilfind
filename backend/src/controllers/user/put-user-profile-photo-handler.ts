import { Expose } from "class-transformer";
import { Request, Response } from "express";
import { Mapper } from "../../utils/mapper";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { IsEnum, IsString } from "class-validator";
import { User, mapToUserResponseDTO } from "../../models/user-model";
import { PostClient } from "../../clients/post-client";
import { PostType, mapToPostResponseDTO } from "../../models/post-model";
import { UserClient } from "../../clients/user-client";

// base endpoint structure
const putUserProfilePhotoHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    // @ts-ignore
    const locals = req.locals;
    const user: User = locals.user;
    const userId = user._id!.toString();

    const profilePhoto: any = req.file;
    if (!profilePhoto) {
      return ApiHelper.getErrorResponseForCrash(res, "Profile Photo is required");
    }

    console.log("profilePhoto", profilePhoto);
    const updated = await UserClient.updateProfilePhoto(userId, profilePhoto.location);

    if (!updated) {
      return ApiHelper.getErrorResponseForCrash(res, "Profile photo could not be updated");
    }

    user.profilePhoto = profilePhoto.location;
    const userGetDto = mapToUserResponseDTO(user);
    return ApiHelper.getSuccessfulResponse(res, { user: userGetDto });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default putUserProfilePhotoHandler;
