import 'package:bilfind_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class NotificationChoiceItem extends StatefulWidget {
  const NotificationChoiceItem(
      {super.key, required this.choiceTitle, required this.isPicked});

  final String choiceTitle;
  final bool isPicked;

  @override
  State<NotificationChoiceItem> createState() => _NotificationChoiceItemState();
}

class _NotificationChoiceItemState extends State<NotificationChoiceItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: AppColors.primary),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.choiceTitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: AppColors.mutedWhite, fontSize: 14)),
              Text(
              widget.choiceTitle == "All"
                  ? "Get all the mails"
                  : widget.choiceTitle == "Only Necessary"
                      ? "Get only the necessary emails"
                      : "No emails",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: AppColors.black6, fontSize: 12)),

            ],
          ),
          !widget.isPicked
                  ? const Icon(
                      Icons.circle_outlined,
                      color: AppColors.mutedWhite,
                      size: 32,
                    )
                  : const Icon(
                      Icons.check_circle,
                      color: AppColors.bilkentBlue,
                      size: 32,
                    )
                  ],
      ),
    );
  }
}
