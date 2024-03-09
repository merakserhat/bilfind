import dotenv from "dotenv";

dotenv.config();

const MONGODB: string = process.env.MONGODB ?? "";

const PORT: number = process.env.PORT ? Number(process.env.PORT) : 3000;

export const config = {
  mongo: MONGODB,
  port: PORT,
};
