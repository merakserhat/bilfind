import { Expose } from "class-transformer";
import { Request, Response } from "express";
import { Mapper } from "../../utils/mapper";
import { ApiHelper } from "../../utils/api-helper";
import * as _ from "lodash";
import Logging from "../../utils/logging";
import { ApiErrorCode } from "../../utils/error-codes";
import { User } from "../../models/user-model";

class GetTestRequest {
  @Expose()
  errorRequest: string;
}

// base endpoint structure
const getTest = (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.query)));

  try {
    // @ts-ignore
    const user: User = req.locals.user;
    const getTestRequest: GetTestRequest = Mapper.map(GetTestRequest, req.query);

    if (getTestRequest.errorRequest === "true") {
      return ApiHelper.getErrorResponse(res, 400, [
        {
          errorCode: ApiErrorCode.WRONG_PASSWORD,
          message: "Password is not correct",
        },
      ]);
    }

    ApiHelper.getSuccessfulResponse(res, { message: "successfully passed the test!", user });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

export default getTest;
