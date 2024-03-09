import { PostClient } from "../clients/post-client";
import { UserClient } from "../clients/user-client";
import { ConversationModel, ConversationResponseDto, mapToConversationResponseDTO } from "../models/conversation_model";
import { PostModel, PostResponseDTO, mapToPostResponseDTO } from "../models/post-model";
import { User } from "../models/user-model";
import Logging from "./logging";

export class DtoMapper {
  async mapConversationListDto(conversations: ConversationModel[]): Promise<ConversationResponseDto[]> {
    // get posts
    const postIdList = conversations.map((conv) => conv.postId);
    const posts = await PostClient.getReportedPost(postIdList);
    const postMap: Record<string, PostModel> = {};
    posts.forEach((post) => (postMap[post._id!.toString()] = post));

    const postOwnerIdList = [
      ...posts.map((post) => post.userId),
      ...conversations.map((conv) => conv.senderUserId),
      ...conversations.map((conv) => conv.postOwnerUserId),
    ];
    const users = await UserClient.getUsersByListId(postOwnerIdList);
    const userMap: Record<string, User> = {};
    users.forEach((user) => (userMap[user._id!.toString()] = user));

    const postDTOMap: Record<string, PostResponseDTO> = {};
    for (const post of posts) {
      const postUser = userMap[post.userId];
      if (!postUser) {
        Logging.error("User not found when mapping " + post.userId);
        continue;
      }

      const postResponseDTO = mapToPostResponseDTO(post, postUser);
      postDTOMap[post._id!.toString()] = postResponseDTO;
    }

    const conversationResponseDtos: ConversationResponseDto[] = [];
    for (const conv of conversations) {
      const senderUser = userMap[conv.senderUserId];
      const postOwner = userMap[conv.postOwnerUserId];
      const postDto = postDTOMap[conv.postId];

      if (!senderUser || !postOwner || !postDto) {
        Logging.error("Required data not found to map conversation response dto " + conv._id!.toString());
        continue;
      }

      const conversationResponseDto = mapToConversationResponseDTO(conv, postDto, senderUser, postOwner);
      conversationResponseDtos.push(conversationResponseDto);
      console.log(conversationResponseDto);
    }

    return conversationResponseDtos;
  }
}
