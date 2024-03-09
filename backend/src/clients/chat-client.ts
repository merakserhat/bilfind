import mongoose from "mongoose";
import { Mapper } from "../utils/mapper";
import Logging from "../utils/logging";
import { ObjectId } from "mongodb";
import { ReportModel, ReportStatus } from "../models/report-model";
import { ConversationModel, ConversationStatus } from "../models/conversation_model";
import { PostModel, PostStatus } from "../models/post-model";
import { MessageModel, MessageType } from "../models/message-model";

export class ChatClient {
  static async createConversation(userId: string, postId: string, otherUserId: string): Promise<ObjectId | null> {
    try {
      const db = mongoose.connection.db;
      const conversationCollection = db.collection("conversation");

      const conversation: ConversationModel = {
        postOwnerUserId: otherUserId,
        senderUserId: userId,
        postId,
        createdAt: new Date(),
        messages: [],
        status: ConversationStatus.WAITING,
      };

      const result = await conversationCollection.insertOne(conversation);
      Logging.info("Conversation successfully created by id: ", result.insertedId._id.toString());

      return result.insertedId._id;
    } catch (error) {
      Logging.error(error);
      return null;
    }
  }

  static async getConversationWithId(id: string) {
    try {
      const db = mongoose.connection.db;
      const postCollection = db.collection("conversation");

      const data = await postCollection.findOne({
        _id: new mongoose.Types.ObjectId(id),
        status: { $ne: ConversationStatus.DELETED },
      });

      const conversationModel: ConversationModel = Mapper.map(ConversationModel, data);
      if (!conversationModel) {
        Logging.error("Conversation not found with id " + id);
        return null;
      }

      Logging.info("Conversation retrieved by id {}", id);

      return conversationModel;
    } catch (error) {
      Logging.error(error);
      return null;
    }
  }

  static async getConversationWithPostAndUser(userId: string, postId: string) {
    try {
      const db = mongoose.connection.db;
      const postCollection = db.collection("conversation");

      const data = await postCollection.findOne({
        postId,
        senderUserId: userId,
        status: { $ne: ConversationStatus.DELETED },
      });

      const conversationModel: ConversationModel = Mapper.map(ConversationModel, data);
      if (!conversationModel) {
        Logging.error("Conversation not found with post and user" + postId + " " + userId);
        return null;
      }

      Logging.info("Conversation not found with post and user" + postId + " " + userId);

      return conversationModel;
    } catch (error) {
      Logging.error(error);
      return null;
    }
  }

  static async insertMessage(conversationId: string, senderId: string, content: string) {
    try {
      const db = mongoose.connection.db;
      const conversationCollection = db.collection("conversation");

      const messageModel: MessageModel = {
        conversationId: conversationId,
        senderId,
        createdAt: new Date(),
        text: content,
        messageType: MessageType.TEXT,
      };

      const filter = {
        _id: new mongoose.Types.ObjectId(conversationId),
      };

      const set = {
        $set: {
          status: ConversationStatus.ACTIVE,
        },
        $push: {
          messages: messageModel,
        },
      };

      const result = await conversationCollection.updateOne(filter, set);
      Logging.info("Message successfully inserted into conversation");

      return result.modifiedCount > 0;
    } catch (error) {
      Logging.error(error);
      return false;
    }
  }

  static async getUserConversations(userId: string) {
    try {
      const db = mongoose.connection.db;
      const conversationCollection = db.collection("conversation");

      const filter = {
        $or: [{ senderUserId: userId }, { postOwnerUserId: userId }],
        status: ConversationStatus.ACTIVE,
      };

      const dataCursor = conversationCollection.find(filter);
      const conversations = (await dataCursor.toArray()).map((dataItem) => Mapper.map(ConversationModel, dataItem));

      Logging.info("Conversation retrieved by user id {}", userId);

      return conversations;
    } catch (error) {
      Logging.error(error);
      return [];
    }
  }
}
