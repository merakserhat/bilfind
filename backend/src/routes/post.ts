import express from "express";
import { isAuth } from "../utils/authentication-helper";
import createPostHandler from "../controllers/post/create-post-handler";
import editPostHandler from "../controllers/post/edit-post-handler";
import { imageUpload } from "../utils/storage-helper";
import getPostListHandler from "../controllers/post/get-post-list-handler";
import postCommentHandler from "../controllers/post/post-comment-handler";
import getPostDetailHandler from "../controllers/post/get-post-detail-handler";
import deleteCommentHandler from "../controllers/post/delete-comment-handler";
import getUserPostsHandler from "../controllers/post/get-user-posts";
import postReportPostHandler from "../controllers/post/post-report-post-handler";
import deletePostHandler from "../controllers/post/delete-post-handler";

const postRouter = express.Router();

postRouter.post("", isAuth, imageUpload.array("image"), createPostHandler);
postRouter.put("", isAuth, imageUpload.array("image"), editPostHandler);
postRouter.get("", isAuth, getPostDetailHandler);
postRouter.delete("", isAuth, deletePostHandler);

postRouter.get("/list", isAuth, getPostListHandler);
postRouter.get("/user", isAuth, getUserPostsHandler);
postRouter.post("/comment", isAuth, postCommentHandler);
postRouter.delete("/comment", isAuth, deleteCommentHandler);
postRouter.post("/:postId/report", isAuth, postReportPostHandler);

export default postRouter;
