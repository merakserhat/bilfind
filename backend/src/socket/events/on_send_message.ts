import { Expose } from "class-transformer";
import { Socket } from "socket.io";
import { sendLog } from "./client_send_log";
import { ChatClient } from "../../clients/chat-client";
import { UserClient } from "../../clients/user-client";
import { User } from "../../models/user-model";
import { MailHelper } from "../../utils/mail-helper";

export class SendMessageData {
  @Expose()
  conversationId: string;

  @Expose()
  userId: string;

  @Expose()
  content: string;
}

export const sendMessage = async (data: SendMessageData, socket: Socket) => {
  try {
    sendLog("Message is sent " + data.content, socket);
    socket.to(data.conversationId).emit("message", data);

    const user = await UserClient.getUserById(data.userId);

    if (!user) {
      sendLog("User not found with id " + data.userId, socket);
      return;
    }

    const conversation = await ChatClient.getConversationWithId(data.conversationId);

    if (!conversation) {
      sendLog("Conversation not found with id " + data.conversationId, socket);
      return;
    }

    const receiverId =
      conversation?.senderUserId === user._id!.toString()
        ? conversation.postOwnerUserId!.toString()
        : conversation?.senderUserId!.toString();

    const receiverUser = await UserClient.getUserById(receiverId!.toString());

    if (conversation.messages.length > 0 && receiverUser && receiverUser.mailSubscription) {
      MailHelper.sendFirstMessageMail(receiverUser.email, user.name, data.content);
    }
    await ChatClient.insertMessage(data.conversationId, data.userId, data.content);
    sendLog("Message successfully saved to database.", socket);
  } catch (error: any) {
    sendLog("Error saving or emitting message: " + error.toString(), socket);
  }
};

/*
async (data: ChatSocketModel) => {
                try {
                    // Emit the saved message to all users in the conversation
                    console.log("message is sent");
                    socket.to(data.conversationId).emit('message', data.message);
                } catch (error) {
                    console.error('Error saving or emitting message:', error);
                }
            }
 */
