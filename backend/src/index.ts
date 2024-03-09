import "reflect-metadata";
import express, { Request, Response, Application } from "express";
import { config } from "./utils/config";
import Logging from "./utils/logging";
import mongoose from "mongoose";
import testRouter from "./routes/test";
import authRouter from "./routes/auth";
import cors from "cors";
import postRouter from "./routes/post";
import userRouter from "./routes/user";
import adminRouter from "./routes/admin";
import { SocketServer } from "./socket/socket_server";
import chatRouter from "./routes/chat";

const app: Application = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.get("/", (req: Request, res: Response): void => {
  res.send("Server is active!");
});

app.use(cors());

///// Routes
app.use("/test", testRouter);
app.use("/auth", authRouter);
app.use("/post", postRouter);
app.use("/user", userRouter);
app.use("/admin", adminRouter);
app.use("/chat", chatRouter);

///// Start Server
const server = app.listen(config.port, async () => {
  const connected = await connectDatabase();
  if (connected) {
    Logging.info(`Server is running at port ${config.port}`);
  }
});

///// Connect to mongo
const connectDatabase = async () => {
  try {
    await mongoose.connect(config.mongo, { retryWrites: true, w: "majority" });
    Logging.info("Connected to database");
    return true;
  } catch (error) {
    Logging.error(error);
    return false;
  }
};

const socketServer = new SocketServer();
socketServer.connect(server);
