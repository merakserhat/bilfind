import express from "express";
import getTest from "../controllers/test/get-test";
import { Request, Response } from "express";
import { isAuth } from "../utils/authentication-helper";

const testRouter = express.Router();

// for test purpose.
testRouter.get("/", (req: Request, res: Response): void => {
  res.send("Get /test route is active!");
});

testRouter.get("/test", getTest);
testRouter.get("/admin", isAuth, getTest);

export default testRouter;
