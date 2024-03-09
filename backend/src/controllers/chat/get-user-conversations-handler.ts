import { Request, Response } from "express";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { User } from "../../models/user-model";
import { PostClient } from "../../clients/post-client";
import { PostModel, PostResponseDTO, mapToPostResponseDTO } from "../../models/post-model";
import { ReportModel, mapToReportResponseDTO } from "../../models/report-model";
import { ReportClient } from "../../clients/report-client";
import { ChatClient } from "../../clients/chat-client";
import { UserClient } from "../../clients/user-client";
import {
  ConversationModel,
  ConversationResponseDto,
  mapToConversationResponseDTO,
} from "../../models/conversation_model";
import { DtoMapper } from "../../utils/dto-mapper";

// base endpoint structure
const getUserConversationsHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    // @ts-ignore
    const locals = req.locals;
    const user: User = locals.user;

    const conversations: ConversationModel[] = await ChatClient.getUserConversations(user._id!.toString());

    const dtoMapper = new DtoMapper();
    const conversationDtoList = await dtoMapper.mapConversationListDto(conversations);

    return ApiHelper.getSuccessfulResponse(res, { conversations: conversationDtoList });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default getUserConversationsHandler;
