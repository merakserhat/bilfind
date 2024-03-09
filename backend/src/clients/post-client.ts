import mongoose from "mongoose";
import { Mapper } from "../utils/mapper";
import Logging from "../utils/logging";
import { ObjectId, UpdateResult } from "mongodb";
import { PostCategory, PostModel, PostStatus, PostType } from "../models/post-model";
import { EditPostRequest } from "../controllers/post/edit-post-handler";
import { SearchFilterModel } from "../controllers/post/get-post-list-handler";
import { PostCommentRequest } from "../controllers/post/post-comment-handler";
import { CommentModel } from "../models/comment-model";
import { User } from "../models/user-model";
import { Departments } from "../utils/enums";

export class PostClient {
  static async getCommentById(commentId: string): Promise<CommentModel | null> {
    try {
      const db = mongoose.connection.db;
      const commentCollection = db.collection("comment");

      const data = await commentCollection.findOne({ _id: new mongoose.Types.ObjectId(commentId), isDeleted: false });

      const comment: CommentModel = Mapper.map(CommentModel, data);
      if (!comment) {
        Logging.error("Comment not found with id " + commentId);
        return null;
      }

      Logging.info("Comment is retrieved by id {}", commentId);

      return comment;
    } catch (error) {
      Logging.error(error);
      return null;
    }
  }

  static async getPostComments(postId: string): Promise<CommentModel[]> {
    try {
      const db = mongoose.connection.db;
      const commentCollection = db.collection("comment");

      const dataCursor = commentCollection.find({ postId, isDeleted: false });
      const postComments = (await dataCursor.toArray()).map((dataItem) => Mapper.map(CommentModel, dataItem));

      return postComments;
    } catch (error) {
      Logging.error(error);
      return [];
    }
  }

  static async createComment(postCommentRequest: PostCommentRequest, user: User): Promise<ObjectId | null> {
    try {
      const db = mongoose.connection.db;
      const commentCollection = db.collection("comment");

      const comment: CommentModel = {
        content: postCommentRequest.content,
        postId: postCommentRequest.postId,
        userId: user._id!.toString(),
        parentId: postCommentRequest.parentId,
        createdAt: new Date(),
        isDeleted: false,
      };

      const result = await commentCollection.insertOne(comment);
      Logging.info("Comment successfully created by id: ", result.insertedId._id.toString());

      return result.insertedId._id;
    } catch (error) {
      Logging.error(error);
      return null;
    }
  }

  static async deleteComment(commentId: string): Promise<boolean> {
    try {
      const db = mongoose.connection.db;
      const commentCollection = db.collection("comment");

      const filter = { $or: [{ _id: new mongoose.Types.ObjectId(commentId) }, { parentId: commentId }] };
      const update = {
        $set: {
          isDeleted: true,
        },
      };
      const data = await commentCollection.updateMany(filter, update);

      Logging.info("Comments are deleted by id {}", commentId);

      return data.modifiedCount > 0;
    } catch (error) {
      Logging.error(error);
      return false;
    }
  }

  // Post
  static async createPost(
    title: string,
    content: string,
    type: PostType,
    userId: string,
    price?: number,
    images?: string[],
    department?: Departments,
    category?: PostCategory
  ): Promise<ObjectId | null> {
    try {
      const db = mongoose.connection.db;
      const postCollection = db.collection("post");

      const post: PostModel = {
        title,
        content,
        type,
        price: price,
        userId,
        images: images,
        createdAt: new Date(),
        isDeleted: false,
        status: PostStatus.ACTIVE,
        department: department,
        category: category,
        favCount: 0,
      };

      const result = await postCollection.insertOne(post);
      Logging.info("Post successfully created by id: ", result.insertedId._id.toString());

      return result.insertedId._id;
    } catch (error) {
      Logging.error(error);
      return null;
    }
  }

  static async getPosts(searchFilterModel: SearchFilterModel) {
    const db = mongoose.connection.db;
    const postCollection = db.collection("post");
    let filter: any = { status: PostStatus.ACTIVE };

    if (searchFilterModel.types && searchFilterModel.types.length > 0) {
      filter.type = { $in: searchFilterModel.types };
    }

    if (searchFilterModel.minPrice !== undefined) {
      filter.price = { $gte: searchFilterModel.minPrice };
    }

    if (searchFilterModel.category) {
      filter.category = searchFilterModel.category;
    }

    if (searchFilterModel.maxPrice !== undefined) {
      filter.price = { ...filter.price, $lte: searchFilterModel.maxPrice };
    }

    if (searchFilterModel.types) {
      filter.type = { $in: searchFilterModel.types! };
    }

    if (searchFilterModel.department) {
      filter.department = searchFilterModel.department;
    }

    if (searchFilterModel.key) {
      const regex = new RegExp(searchFilterModel.key!, "i");
      const or: any = {
        $or: [
          {
            content: { $regex: regex },
          },
          {
            title: { $regex: regex },
          },
        ],
      };
      if (searchFilterModel.userIdList) {
        or.$or.push({
          userId: { $in: searchFilterModel.userIdList! },
        });
      }
      filter = {
        ...filter,
        ...or,
      };
    }

    console.log("searchFilterModel");
    console.log(searchFilterModel);
    console.log(filter.$or);

    if (!searchFilterModel.page) {
      searchFilterModel.page = 0;
    }

    const dataCursor = postCollection
      .find(filter, { sort: { createdAt: -1 } })
      .skip(searchFilterModel.page * 36)
      .limit(36);
    const posts = (await dataCursor.toArray()).map((dataItem) => Mapper.map(PostModel, dataItem));

    return posts;
  }

  static async getPostsByIdList(postIdList: string[]) {
    const db = mongoose.connection.db;
    const postCollection = db.collection("post");

    const objectIdList = postIdList.map((postId) => new mongoose.Types.ObjectId(postId));
    const filter: any = { status: PostStatus.ACTIVE, _id: { $in: objectIdList } };

    const dataCursor = postCollection.find(filter, { sort: { createdAt: -1 } });
    const posts = (await dataCursor.toArray()).map((dataItem) => Mapper.map(PostModel, dataItem));

    return posts;
  }

  static async getReportedPost(postIdList: string[]) {
    const db = mongoose.connection.db;
    const postCollection = db.collection("post");

    //todo
    const objectIdList = postIdList.map((postId) => new mongoose.Types.ObjectId(postId));
    const filter: any = { _id: { $in: objectIdList } };

    const dataCursor = postCollection.find(filter, { sort: { createdAt: -1 } });
    const posts = (await dataCursor.toArray()).map((dataItem) => Mapper.map(PostModel, dataItem));

    return posts;
  }

  static async getPostsByUserId(userId: string) {
    const db = mongoose.connection.db;
    const postCollection = db.collection("post");

    const filter: any = { status: PostStatus.ACTIVE, userId: userId };

    const dataCursor = postCollection.find(filter, { sort: { createdAt: -1 } });
    const posts = (await dataCursor.toArray()).map((dataItem) => Mapper.map(PostModel, dataItem));

    return posts;
  }

  static async editPost(eidtPostFilter: EditPostRequest, userId: string): Promise<boolean> {
    try {
      const db = mongoose.connection.db;
      const postCollection = db.collection("post");

      const filter = { _id: new mongoose.Types.ObjectId(eidtPostFilter.postId), userId: userId };
      const update = {
        $set: {
          title: eidtPostFilter.title,
          content: eidtPostFilter.content,
          price: eidtPostFilter.price ? +eidtPostFilter.price : null,
          images: eidtPostFilter.images,
          department: eidtPostFilter.department,
          category: eidtPostFilter.category,
        },
      };

      const result = await postCollection.updateOne(filter, update);
      Logging.info("Post successfully updated with id", eidtPostFilter.postId);

      return true;
    } catch (error) {
      Logging.error(error);
      return false;
    }
  }

  static async getPostById(id: string): Promise<PostModel | null> {
    try {
      const db = mongoose.connection.db;
      const postCollection = db.collection("post");

      const data = await postCollection.findOne({
        _id: new mongoose.Types.ObjectId(id),
        status:  PostStatus.ACTIVE,
      });

      const post: PostModel = Mapper.map(PostModel, data);
      if (!post) {
        Logging.error("Post not found with id " + id);
        return null;
      }

      Logging.info("Post is retrieved by id {}", id);

      return post;
    } catch (error) {
      Logging.error(error);
      return null;
    }
  }

  static async deleteUserPosts(userId: string): Promise<boolean> {
    try {
      const db = mongoose.connection.db;
      const postCollection = db.collection("post");

      const filter = { userId };

      const update = {
        $set: {
          isDeleted: true,
          status: PostStatus.DELETED,
        },
      };

      const result: UpdateResult = await postCollection.updateMany(filter, update);
      Logging.info("User posts successfully deleted");

      return result.modifiedCount > 0;
    } catch (error) {
      Logging.error(error);
      return false;
    }
  }

  static async deleteUserComments(userId: string): Promise<boolean> {
    try {
      const db = mongoose.connection.db;
      const commentCollection = db.collection("comment");

      const filter = { userId };

      const update = {
        $set: {
          isDeleted: true,
        },
      };

      const result: UpdateResult = await commentCollection.updateMany(filter, update);
      Logging.info("User comments successfully deleted");

      return result.modifiedCount > 0;
    } catch (error) {
      Logging.error(error);
      return false;
    }
  }

  static async updatePostStatus(postId: string, status: string) {
    try {
      const db = mongoose.connection.db;
      const postCollection = db.collection("post");
      const update = {
        $set: {
          status: status,
        },
      };

      const filter = { _id: new mongoose.Types.ObjectId(postId) };

      const result: UpdateResult = await postCollection.updateOne(filter, update);
      Logging.info("Post status successfully updated");

      return result.modifiedCount > 0;
    } catch (error) {
      Logging.error(error);
      return false;
    }
  }
  static async updateFavCount(postId: string, res: number) {
    try {
      const db = mongoose.connection.db;
      const postCollection = db.collection("post");

      const update = {
        $set: {
          favCount: res,
        },
      };

      const filter = { _id: new mongoose.Types.ObjectId(postId) };

      const result: UpdateResult = await postCollection.updateOne(filter, update);
      Logging.info("Post status successfully updated");

      return result.modifiedCount > 0;
    } catch (error) {
      Logging.error(error);
      return false;
    }
  }
}
