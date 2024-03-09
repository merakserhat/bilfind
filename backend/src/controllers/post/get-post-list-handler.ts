import { Expose } from "class-transformer";
import { Request, Response } from "express";
import { Mapper } from "../../utils/mapper";
import { ApiHelper } from "../../utils/api-helper";
import Logging from "../../utils/logging";
import { User } from "../../models/user-model";
import { PostClient } from "../../clients/post-client";
import { PostCategory, PostModel, PostType, mapToPostResponseDTO } from "../../models/post-model";
import { UserClient } from "../../clients/user-client";
import { ObjectId } from "mongodb";
import { Departments } from "../../utils/enums";
import { IsEnum, isEnum } from "class-validator";

export class SearchFilterModel {
  @Expose()
  public key?: string;

  @Expose()
  public userIdList?: ObjectId[];

  @Expose()
  public types?: string[];

  @Expose()
  public minPrice?: number;

  @Expose()
  public maxPrice?: number;

  @Expose()
  public department?: Departments;

  @Expose()
  category?: PostCategory;

  @Expose()
  page?: number;
}

// base endpoint structure
const getPostListHandler = async (req: Request, res: Response) => {
  try {
    const searchFilterModel: SearchFilterModel = mapQueryToFilter(req.query);
    if (searchFilterModel.key) {
      const userKey = extractUsername(searchFilterModel.key);
      console.log(userKey);
      if (userKey) {
        const users = await UserClient.getUsersByRegex(userKey);
        console.log(users);
        searchFilterModel.userIdList = users.map((user) => user._id!);
      }
    }

    let postList: PostModel[] = await PostClient.getPosts(searchFilterModel);

    const postOwnerIdList = postList.map((post) => post.userId);
    const users = await UserClient.getUsersByListId(postOwnerIdList);
    const userMap: Record<string, User> = {};
    users.forEach((user) => (userMap[user._id!.toString()] = user));
    postList = postList.filter((post) => userMap[post.userId]);
    const getPostDTOList = postList.map((post) => mapToPostResponseDTO(post, userMap[post.userId]));

    return ApiHelper.getSuccessfulResponse(res, { posts: getPostDTOList });
  } catch (error) {
    Logging.error(error);

    if (ApiHelper.isInvalidRequestBodyError(error)) {
      return ApiHelper.getErrorResponseForInvalidRequestBody(res);
    }
    ApiHelper.getErrorResponseForCrash(res, JSON.stringify(Object.getOwnPropertyNames(req)));
  }
};

function mapQueryToFilter(query: any): SearchFilterModel {
  return {
    key: query.key as string,
    types: Array.isArray(query.types) ? query.types : typeof query.types === "string" ? [query.types] : undefined,
    minPrice: query.minPrice ? parseInt(query.minPrice as string) : undefined,
    maxPrice: query.maxPrice ? parseInt(query.maxPrice as string) : undefined,
    department: query.department ? (query.department as Departments) : undefined,
    category: query.category ? (query.category as PostCategory) : undefined,
    page: query.page ? parseInt(query.page as string) : undefined,
  };
}

function extractUsername(inputString: string): string | null {
  const regex = /@([a-zA-Z0-9_]+)/;
  const match = inputString.match(regex);

  // If there is a match, return the captured group (anyname), otherwise return null
  return match ? match[1] : null;
}

export default getPostListHandler;
