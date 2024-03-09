import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/report_model.dart';
import 'package:bilfind_app/screens/post_detail/widgets/post_item.dart';
import 'package:bilfind_app/services/report_service.dart';
import 'package:bilfind_app/widgets/app_button.dart';
import 'package:bilfind_app/widgets/popups/warning_popup.dart';
import 'package:flutter/material.dart';

class AdminViewReportedPostItem extends StatefulWidget {
  const AdminViewReportedPostItem({super.key, required this.reportModel});

  final ReportModel reportModel;

  @override
  State<AdminViewReportedPostItem> createState() =>
      _AdminViewReportedPostItemState();
}

class _AdminViewReportedPostItemState extends State<AdminViewReportedPostItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: AppColors.black3,
      ),
      child: Column(children: [
        SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: widget.reportModel.status == "ACTIVE"
                    ? Colors.blue
                    : widget.reportModel.status == "REJECTED"
                        ? Colors.red
                        : widget.reportModel.status == "ACCEPTED"
                            ? Colors.green
                            : Colors.amber,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              height: 40,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text(
                  widget.reportModel.status == "ACTIVE"
                      ? "UNDER YOUR EVALUATION"
                      : widget.reportModel.status,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: AppColors.mutedWhite),
                ),
              ),
            )),
        const SizedBox(
          height: 12,
        ),
        PostItem(
          postModel: widget.reportModel.postModel,
          isAdminView: true,
          isUnderEvaluation: widget.reportModel.status == "ACTIVE",
        ),
        widget.reportModel.status == "ACTIVE"
            ? _getAcceptReportButton()
            : Container(),
        widget.reportModel.status == "ACTIVE"
            ? _getRejectReportButton()
            : Container(),
      ]),
    );
  }

  Widget _getAcceptReportButton() {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: AppButton(
        label: "Accept",
        textColor: Colors.green,
        onPressed: onAcceptReportClicked,
        color: AppColors.black4,
      ),
    );
  }

  Widget _getRejectReportButton() {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: AppButton(
        label: "Reject",
        textColor: Colors.red,
        onPressed: onRejectReportClicked,
        color: AppColors.black4,
      ),
    );
  }

  onAcceptReportClicked() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WarningPopup(
          title: "Accept Report",
          content: "Are you sure you want to accept this report?",
          approveLabel: "Accept",
          onApproved: onReportStatusAccepted, //
          isAsync: true,
        );
      },
    );
  }

  onRejectReportClicked() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WarningPopup(
          title: "Reject Report",
          content: "Are you sure you want to reject this report?",
          approveLabel: "Reject",
          onApproved: onReportStatusRejected,
          isAsync: true,
        );
      },
    );
  }

  void onReportStatusRejected() async {
    bool result = await ReportService.changeReportStatus(
        widget.reportModel.id, "REJECTED");

    if (result) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "You have rejected this report.",
          ),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 1300),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Something went wrong",
          ),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 1300),
        ),
      );
    }
  }

  void onReportStatusAccepted() async {
    bool result = await ReportService.changeReportStatus(
        widget.reportModel.id, "ACCEPTED");

    if (result) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "You have accepted this report. Post is banned.",
          ),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 1300),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Something went wrong",
          ),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 1300),
        ),
      );
    }
  }
}
