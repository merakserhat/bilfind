import express from "express";
import putUserFavHandler from "../controllers/user/put-user-fav-handler";
import { isAuth } from "../utils/authentication-helper";
import { imageUpload } from "../utils/storage-helper";
import putUserProfilePhotoHandler from "../controllers/user/put-user-profile-photo-handler";
import getUserReportsHandler from "../controllers/user/get-user-report-handler";
import getUserHandler from "../controllers/user/get-user-handler";
import putUserMailSubscriptionHandler from "../controllers/user/put-user-update-mail-subscription-handler";
import putUserEditHandler from "../controllers/user/put-user-edit-handler";

const userRouter = express.Router();

userRouter.put("/fav", isAuth, putUserFavHandler);
userRouter.put("", isAuth, putUserEditHandler);
userRouter.put("/photo", isAuth, imageUpload.single("image"), putUserProfilePhotoHandler);
userRouter.get("/reports", isAuth, getUserReportsHandler);
userRouter.put("/subs", isAuth, putUserMailSubscriptionHandler);
userRouter.get("", isAuth, getUserHandler);

export default userRouter;
