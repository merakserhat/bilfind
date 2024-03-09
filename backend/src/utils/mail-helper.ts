import { createTransport } from "nodemailer";
import { Otp } from "../models/otp-model";
import Logging from "./logging";
import { UserClient } from "../clients/user-client";
import { ApiHelper } from "./api-helper";
import { ApiErrorCode } from "./error-codes";
import { error } from "console";

export class MailHelper {
  public static sendMail(to: string, content: string, subject: string) {
    //sending email to the related user
    const transporter = createTransport({
      service: "gmail",
      auth: {
        user: process.env.HOST_MAIL,
        pass: process.env.HOST_MAIL_PASSWORD,
      },
    });

    const mailOptions = {
      from: process.env.HOST_MAIL,
      to,
      subject,
      text: content,
    };

    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        Logging.error(error);
      } else {
        Logging.log("Email sent: " + info.response);
      }
    });
  }

  public static sendRegisterOtpMail(otp: Otp) {
    const content = `Hello from Bilfind!\n\nYour verification code is: ${otp.code}\n\nThis code is used to verify your identity for Bilfind.Please enter it in the app to complete the verification process. Keep your account secure by not sharing this code with anyone.\n\nIf you didn't request this code, please ignore this message.\n\nThank you for using Bilfind!`;

    const subject = "Your Bilfind Verification Code";
    this.sendMail(otp.email, content, subject);
  }

  public static sendResetOtpMail(otp: Otp) {
    const content = `Hello from Bilfind!\n\nYour otp code to reset password is: ${otp.code}\n\nThis code is used to reset your Bilfind password. Please enter it in the app to complete the password reset process.\n\nIf you didn't request this code, please ignore this message.\n\nThank you for using Bilfind!`;

    const subject = "Your Bilfind Reset Password Code";
    this.sendMail(otp.email, content, subject);
  }

  //optional
  public static sendBannedMail(to: string) {
    const content = `Hello from Bilfind!\n\nYou have been banned from BilFind indefinitely. \n\nIf you think there is a problem, please contact us.\n\nThank you for using Bilfind!`;

    const subject = "You are Banned from Bilfind!";
    this.sendMail(to, content, subject);
  }

  public static sendReportStatusUpdateMail(to: string, reportedName: string, reportStatus: string) {
    const content = `Hello from Bilfind!\n\nWe reviewed ${reportedName}'s post you reported. \n\n Current status of your report: ${reportStatus}.\n\nThank you for using Bilfind!`;

    const subject = "We Reviewed Your Report!";
    this.sendMail(to, content, subject);
  }

  public static sendReportStatusUpdateMailtoPostOwner(to: string, postTitle: string) {
    const content = `Hello from Bilfind!\n\nWe reviewed your post with id ${postTitle} and decided to remove it because it does not comply with our community rules.\n\nThank you for using Bilfind!`;

    const subject = "We removed your post!";
    this.sendMail(to, content, subject);
  }

  public static sendMailCommentedPostOwner(to: string, userName: string, postTitle: string, comment: string) {
    const content = `Hello from Bilfind!\n\n ${userName} commented on your post named "${postTitle}":\n\n"${comment}"\n\nThank you for using Bilfind!`;
    const subject = "You have a comment!";
    this.sendMail(to, content, subject);
  }

  public static sendMailRepliedCommentOwner(
    to: string,
    userName: string,
    parentComment: string,
    comment: string,
    postOwnerName: string,
    postTitle: string
  ) {
    const content = `Hello from Bilfind!\n\n${userName} responded to your comment "${parentComment}" of ${postOwnerName}'s post named "${postTitle}":\n\n"${comment}"\n\nThank you for using Bilfind!`;
    const subject = "You have a comment!";
    this.sendMail(to, content, subject);
  }

  public static sendFirstMessageMail(to: string, sender: string, text: string) {
    const content = `Hello from Bilfind!\n\n${sender} sent you a private message :\n\n"${text}"\n\nThank you for using Bilfind!`;
    const subject = "You have a message!";
    this.sendMail(to, content, subject);
  }
}
