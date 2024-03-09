import express from "express";
import putUserFavHandler from "../controllers/user/put-user-fav-handler";
import { isAdminAuth, isAuth } from "../utils/authentication-helper";
import { imageUpload } from "../utils/storage-helper";
import putUserProfilePhotoHandler from "../controllers/user/put-user-profile-photo-handler";
import getReportHandler from "../controllers/admin/get-report-handler";
import putAdminReportHandler from "../controllers/admin/put-report-handler";
import putAdminBanHandler from "../controllers/admin/put-banned-handler";

const adminRouter = express.Router();

adminRouter.get("/report", isAdminAuth, getReportHandler);
adminRouter.put("/:userId/ban", isAdminAuth, putAdminBanHandler);
adminRouter.put("/:reportId/:status", isAdminAuth, putAdminReportHandler);

export default adminRouter;
