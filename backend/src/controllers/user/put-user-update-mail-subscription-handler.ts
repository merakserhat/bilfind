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

class PutMailSubscriptionRequest {
  @Expose()
  subscription: boolean;
}

// base endpoint structure
const putUserMailSubscriptionHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    // @ts-ignore
    const locals = req.locals;
    const user: User = locals.user;
    const userId = user._id!.toString();

    const putMailSubRequest: PutMailSubscriptionRequest = Mapper.map(PutMailSubscriptionRequest, req.body);

    const updated = await UserClient.updateMailSubscription(userId, putMailSubRequest.subscription);

    if (!updated) {
      return ApiHelper.getErrorResponseForCrash(res, "Mail Subscription could not be updated");
    }

    return ApiHelper.getSuccessfulResponse(res, "Successfully Updated");
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default putUserMailSubscriptionHandler;
