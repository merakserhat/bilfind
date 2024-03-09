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
import { Departments } from "../../utils/enums";

class PutUserEditRequest {
  @Expose()
  name?: string;

  @Expose()
  public department?: Departments;
}

// base endpoint structure
const putUserEditHandler = async (req: Request, res: Response) => {
  Logging.info(JSON.stringify(req.query, Object.getOwnPropertyNames(req.body)));
  try {
    const editPostRequest: PutUserEditRequest = Mapper.map(PutUserEditRequest, req.body);

    // @ts-ignore
    const locals = req.locals;
    const user: User = locals.user;
    const userId = user._id!.toString();

    const name: any = editPostRequest.name;
    console.log(name);
    if (name) {
      const nameWords: string[] = name.split(" ");
      const surname: string = nameWords[nameWords.length - 1];
      const firstname: string = nameWords.slice(0, nameWords.length - 1).join(" ");

      await UserClient.updateName(userId, firstname, surname);
    }

    const dep: any = editPostRequest.department;
    if (dep) {
      await UserClient.updateDepartment(userId, dep);
    }

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

export default putUserEditHandler;
