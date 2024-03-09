import mongoose from "mongoose";
import { Mapper } from "../utils/mapper";
import Logging from "../utils/logging";
import { ObjectId, UpdateResult } from "mongodb";
import { ReportModel, ReportStatus } from "../models/report-model";

export class ReportClient {
  static async createReport(userId: string, postId: string, content?: string): Promise<ObjectId | null> {
    try {
      const db = mongoose.connection.db;
      const reportCollection = db.collection("report");

      const report: ReportModel = {
        userId,
        postId,
        content: content,
        createdAt: new Date(),
        status: ReportStatus.ACTIVE,
      };

      const result = await reportCollection.insertOne(report);
      Logging.info("Report successfully created by id: ", result.insertedId._id.toString());

      return result.insertedId._id;
    } catch (error) {
      Logging.error(error);
      return null;
    }
  }

  static async getReportById(id: string): Promise<ReportModel | null> {
    try {
      const db = mongoose.connection.db;
      const reportCollection = db.collection("report");

      const data = await reportCollection.findOne({
        _id: new mongoose.Types.ObjectId(id),
      });

      const report: ReportModel = Mapper.map(ReportModel, data);
      if (!report) {
        Logging.error("Report not found with id " + id);
        return null;
      }

      Logging.info("Report is retrieved by id {}", id);

      return report;
    } catch (error) {
      Logging.error(error);
      return null;
    }
  }

  static async getReportsByIdList(reportIdList: string[]) {
    try {
      const db = mongoose.connection.db;
      const reportCollection = db.collection("report");

      const objectIdList = reportIdList.map((reportId) => new mongoose.Types.ObjectId(reportId));
      const filter: any = { _id: { $in: objectIdList } };

      const dataCursor = reportCollection.find(filter, { sort: { createdAt: -1 } });
      const reports = (await dataCursor.toArray()).map((dataItem) => Mapper.map(ReportModel, dataItem));

      return reports;
    } catch (error) {
      Logging.error(error);
      return [];
    }
  }

  static async getReports(): Promise<ReportModel[]> {
    try {
      const db = mongoose.connection.db;
      const reportCollection = db.collection("report");

      const dataCursor = reportCollection.find({
        status: { $in: [ReportStatus.ACTIVE, ReportStatus.ACCEPTED, ReportStatus.REJECTED] },
      });
      const reports = (await dataCursor.toArray()).map((dataItem) => Mapper.map(ReportModel, dataItem));

      return reports;
    } catch (error) {
      Logging.error(error);
      return [];
    }
  }

  static async updateReportStatus(reportId: string, postId: string, status: string) {
    try {
      const db = mongoose.connection.db;
      const reportCollection = db.collection("report");
      const update = {
        $set: {
          status: status,
        },
      };

      if (status === ReportStatus.ACCEPTED) {
        const filter = { postId: postId };

        const result: UpdateResult = await reportCollection.updateMany(filter, update);
        Logging.info("Report type successfully updated");

        return result.modifiedCount > 0;
      }

      const filter = { _id: new mongoose.Types.ObjectId(reportId) };

      const result: UpdateResult = await reportCollection.updateOne(filter, update);
      Logging.info("Report type successfully updated");

      return result.modifiedCount > 0;
    } catch (error) {
      Logging.error(error);
      return false;
    }
  }

  static async deleteUsersReports(userId: string) {
    try {
      const db = mongoose.connection.db;
      const reportCollection = db.collection("report");
      const update = {
        $set: {
          status: ReportStatus.DELETED,
        },
      };

      const filter = { userId };

      const result: UpdateResult = await reportCollection.updateMany(filter, update);
      Logging.info("Report type successfully updated");

      return result.modifiedCount > 0;
    } catch (error) {
      Logging.error(error);
      return false;
    }
  }
}
