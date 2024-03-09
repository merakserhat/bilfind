import express from "express";
import { isAuth } from "../utils/authentication-helper";

import createConversationHandler from "../controllers/chat/create-conversation-handler";
import getUserConversationsHandler from "../controllers/chat/get-user-conversations-handler";

const chatRouter = express.Router();

chatRouter.post("", isAuth, createConversationHandler);
chatRouter.get("/conversations", isAuth, getUserConversationsHandler);

export default chatRouter;
