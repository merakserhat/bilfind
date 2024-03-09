import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/report_model.dart';
import 'package:bilfind_app/screens/post_detail/widgets/post_item.dart';
import 'package:flutter/material.dart';

class ReportedPostItem extends StatefulWidget {
  const ReportedPostItem({super.key, required this.reportModel});

  final ReportModel reportModel;

  @override
  State<ReportedPostItem> createState() => _ReportedPostItemState();
}

class _ReportedPostItemState extends State<ReportedPostItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: AppColors.black3,
      ),
      child: Column(
        children: [
          SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.reportModel.status == "ACTIVE" ? Colors.blue : widget.reportModel.status == "REJECTED" ? Colors.red : widget.reportModel.status == "ACCEPTED" ? Colors.green : Colors.amber,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    widget.reportModel.status == "ACTIVE" ? "UNDER EVALUATION" : widget.reportModel.status,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.mutedWhite),
                  ),
                ),
              )),
          const SizedBox(
            height: 12,
          ),
          PostItem(postModel: widget.reportModel.postModel),
        ],
      ),
    );
  }
}
