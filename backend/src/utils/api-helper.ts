import { Expose, Type } from "class-transformer";
import { Response } from "express";
import { ApiErrorCode } from "./error-codes";
import * as _ from "lodash";

enum ApiStatus {
  SUCCESS = "success",
  FAIL = "fail",
  ERROR = "error",
}

export class ApiError {
  @Expose()
  message: string;

  @Expose()
  errorCode: ApiErrorCode;
}

class ResponseModel {
  @Expose() status: ApiStatus;
  @Expose() errors: ApiError[];
  @Expose() data?: {};
}

export class ApiHelper {
  static getResponse(res: Response, statusCode: number, body: ResponseModel) {
    res.status(statusCode).json(body);
  }

  static getSuccessfulResponse(res: Response, body?: {}) {
    return this.getResponse(res, 200, {
      status: ApiStatus.SUCCESS,
      data: body || undefined,
      errors: [],
    });
  }

  static getErrorResponse(res: Response, statusCode: number, errorResponse: ApiError[]) {
    return this.getResponse(res, statusCode, {
      status: ApiStatus.FAIL,
      errors: errorResponse,
    });
  }

  static getErrorResponseForCrash(res: Response, errorMessage: string) {
    const errorResponse: ApiError[] = [
      {
        errorCode: ApiErrorCode.SOMETHING_BAD_HAPPENED,
        message: errorMessage,
      },
    ];

    return this.getErrorResponse(res, 400, errorResponse);
  }

  static getErrorResponseForInvalidRequestBody(res: Response) {
    const errorResponse: ApiError[] = [
      {
        errorCode: ApiErrorCode.INVALID_REQUEST_BODY,
        message: "Please make sure that you sent the properties with valid types",
      },
    ];

    return this.getErrorResponse(res, 400, errorResponse);
  }

  static getErrorResponseForUnauthorized(res: Response) {
    const errorResponse: ApiError[] = [
      {
        errorCode: ApiErrorCode.UNAUTHORIZED,
        message: "Authentication failed.",
      },
    ];

    return this.getErrorResponse(res, 401, errorResponse);
  }

  static isInvalidRequestBodyError(error: any): boolean {
    return error && error.message && _.toString(error.message).includes(ApiErrorCode.INVALID_REQUEST_BODY);
  }
}
