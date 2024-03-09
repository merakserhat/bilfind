import { Expose } from "class-transformer";
import { Request, Response } from "express";
import { Mapper } from "../../utils/mapper";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { IsEnum, IsString } from "class-validator";
import { User } from "../../models/user-model";
import { PostClient } from "../../clients/post-client";
import { Multer } from "multer";
import { PostCategory, mapToPostResponseDTO } from "../../models/post-model";
import { Departments } from "../../utils/enums";

export class EditPostRequest {
  @Expose()
  @IsString()
  postId: string;

  @Expose()
  title?: string;

  @Expose()
  content?: string;

  @Expose()
  price?: number;

  @Expose()
  images?: any;

  @Expose()
  department?: Departments;

  @Expose()
  category?: PostCategory;
}

// base endpoint structure
const editPostHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    const editPostRequest: EditPostRequest = Mapper.map(EditPostRequest, req.body);

    // @ts-ignore
    const locals = req.locals;
    const user: User = locals.user;
    const userId = user._id!.toString();

    const post = await PostClient.getPostById(editPostRequest.postId);

    if (!post) {
      return ApiHelper.getErrorResponseForCrash(res, "Post could not be found");
    }

    if (userId !== post.userId) {
      return ApiHelper.getErrorResponseForCrash(res, "Post does not belong to this user");
    }

    const files = req.files;
    console.log(files);

    const images: any =
      typeof editPostRequest.images === "string" ? [editPostRequest.images] : editPostRequest.images ?? [];
    console.log(images);
    if (files && typeof files.length === "number") {
      for (let i = 0; i < (files.length as number); i++) {
        const file = (files as any[])[i];
        images.push(file.location);
      }
    }
    console.log(images);
    editPostRequest.images = images;
    const updated = await PostClient.editPost(editPostRequest, userId);

    if (!updated) {
      return ApiHelper.getErrorResponseForCrash(res, "Post could not be edited");
    }

    const postUpdated = await PostClient.getPostById(editPostRequest.postId);

    if (!postUpdated) {
      return ApiHelper.getErrorResponseForCrash(res, "Post could not be edited");
    }

    const postResponseDto = mapToPostResponseDTO(postUpdated, user);

    return ApiHelper.getSuccessfulResponse(res, { post: postResponseDto });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default editPostHandler;
