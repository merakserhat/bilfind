import { Expose } from "class-transformer";
import { Request, Response } from "express";
import { Mapper } from "../../utils/mapper";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { IsString } from "class-validator";
import { mapToUserResponseDTO, User } from "../../models/user-model";
import { PostClient } from "../../clients/post-client";
import { ChatClient } from "../../clients/chat-client";
import { ConversationStatus } from "../../models/conversation_model";
import { DtoMapper } from "../../utils/dto-mapper";

class CreateConversationRequest {
  @Expose()
  @IsString()
  postId: string;
}

// base endpoint structure
const CreateConversationHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.body, Object.getOwnPropertyNames(req.body)));
  try {
    const createConversationRequest: CreateConversationRequest = Mapper.map(CreateConversationRequest, req.body);

    // @ts-ignore
    const locals = req.locals;
    const user: User = locals.user;
    const userId = user._id!.toString();

    const post = await PostClient.getPostById(createConversationRequest.postId);

    if (!post) {
      return ApiHelper.getErrorResponseForCrash(res, "Post could not be found");
    }

    console.log(post.userId);
    console.log(userId);
    if (post.userId === userId) {
      return ApiHelper.getErrorResponseForCrash(res, "You can not start conversation with yourself.");
    }

    let conversation = await ChatClient.getConversationWithPostAndUser(userId, createConversationRequest.postId);

    if (!conversation) {
      const conversationId = await ChatClient.createConversation(userId, createConversationRequest.postId, post.userId);

      if (!conversationId) {
        return ApiHelper.getErrorResponseForCrash(res, "Conversation could not be created");
      }

      conversation = await ChatClient.getConversationWithId(conversationId.toString());

      if (!conversation) {
        return ApiHelper.getErrorResponseForCrash(res, "Conversation could not be created");
      }
    }

    const dtoMapper = new DtoMapper();
    const conversationDtoList = await dtoMapper.mapConversationListDto([conversation]);

    if (!conversationDtoList || conversationDtoList.length === 0) {
      return ApiHelper.getErrorResponseForCrash(res, "Conversation could not be created");
    }

    ApiHelper.getSuccessfulResponse(res, {
      message: "Conversation created",
      conversation: conversationDtoList[0],
    });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default CreateConversationHandler;
