import * as aws from "aws-sdk";
import { S3Client } from "@aws-sdk/client-s3";
import { EndpointV2 } from "@smithy/types";
import multer, { diskStorage } from "multer";
import multerS3 from "multer-s3";
import path from "path";

const accessKeyId: string = process.env.STORAGE_ACCESS_KEY!;
const secretAccessKey: string = process.env.STORAGE_SECRET_ACCESS_KEY!;

const s3Config = new S3Client({
  forcePathStyle: true,
  region: "eu-central-1",
  endpoint: "https://bilfind.fra1.digitaloceanspaces.com",
  credentials: {
    accessKeyId: accessKeyId,
    secretAccessKey: secretAccessKey,
  },
});

export const imageUpload = multer({
  limits: {
    fileSize: 10000000, // 10000000 Bytes = 10 MB
  },
  fileFilter(req, file, cb) {
    if (!file.originalname.match(/\.(png|jpg|jfif|jpeg)$/)) {
      // upload only png and jpg format
      return cb(new Error("Please upload a Image"));
    }
    cb(null, true);
  },
  storage: multerS3({
    s3: s3Config,
    bucket: "bilfind",
    acl: "public-read",
    metadata: function (req, file, cb) {
      cb(null, { fieldName: file.fieldname });
    },
    key: function (req, file, cb) {
      // @ts-ignore
      cb(null, req.locals.email.split("@")[0] + "_" + Date.now() + path.extname(file.originalname));
    },
  }),
});
