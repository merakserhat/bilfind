import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/screens/post_detail/post_detail_screen.dart';
import 'package:flutter/material.dart';

class CommentBox extends StatelessWidget {
  const CommentBox(
      {super.key, required this.controller, this.replyCommentModel});

  final TextEditingController controller;
  final ReplyCommentModel? replyCommentModel;

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 7,
      maxLines: null,
      controller: controller,
      cursorColor: AppColors.mutedWhite,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: AppColors.mutedWhite),
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.black4,
          hintText: replyCommentModel == null
              ? "What do you think about this post?"
              : "Reply to @${replyCommentModel!.username}",
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: AppColors.subText),
          border: const OutlineInputBorder()),
    );
  }
}
