import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/comment_model.dart';
import 'package:bilfind_app/utils/util_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentAnswerListItem extends StatelessWidget {
  const CommentAnswerListItem({Key? key, required this.commentModel})
      : super(key: key);

  final CommentModel commentModel;
  final String image =
      "https://miro.medium.com/v2/resize:fit:395/0*yt7Mwvdb8e08xxhk.jpg";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        commentModel.ownerPhoto ?? image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w300,
                        color: AppColors.mutedWhite),
                    children: <TextSpan>[
                      TextSpan(
                          text: commentModel.ownerName + " ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white)),
                      TextSpan(
                        text: commentModel.content,
                      ),
                      TextSpan(
                          text:
                              "\n${UtilFunctions.formatTimeElapsed(commentModel.createdAt)}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: AppColors.subText)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
