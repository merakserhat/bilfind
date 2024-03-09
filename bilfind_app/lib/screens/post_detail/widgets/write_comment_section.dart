import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/screens/post_detail/post_detail_screen.dart';
import 'package:bilfind_app/screens/post_detail/widgets/comment_box.dart';
import 'package:bilfind_app/screens/post_detail/widgets/comment_section.dart';
import 'package:bilfind_app/widgets/app_button.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/material.dart';

class WriteCommentSection extends StatelessWidget {
  const WriteCommentSection({
    Key? key,
    this.replyCommentModel,
    required this.commentController,
    required this.commentCreateLoading,
    required this.createComment,
    required this.clearReplyModel,
  }) : super(key: key);

  final ReplyCommentModel? replyCommentModel;
  final TextEditingController commentController;
  final bool commentCreateLoading;
  final Function({required String content, String? parentId}) createComment;
  final VoidCallback clearReplyModel;

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: _getMobileLayout(context),
        tablet: _getMobileLayout(context),
        desktop: _getDesktopLayout(context));
  }

  Widget _getDesktopLayout(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: _getWriteCommentTitle(context),
        ),
        const SizedBox(
          height: 4,
        ),
        // CommentBox(),
        SizedBox(
          height: 120,
          child: CommentBox(
              controller: commentController,
              replyCommentModel: replyCommentModel),
        ),
        const SizedBox(
          height: 12,
        ),
        _getCommentButton(),
      ],
    );
  }

  Widget _getMobileLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.backgroundColor, // Start color with white and opacity 0.6
            AppColors.backgroundColor
                .withOpacity(0.6), // End color with white and opacity 0.0
          ],
          begin: Alignment(0.0, -0.7), // Start from 80% top
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: _getWriteCommentTitle(context)),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: CommentBox(
                    controller: commentController,
                    replyCommentModel: replyCommentModel,
                  ),
                ),
                const SizedBox(width: 4),
                commentCreateLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator())
                    : InkWell(
                        onTap: () {
                          createComment(
                            content: commentController.text,
                            parentId: replyCommentModel?.commentIt,
                          );
                        },
                        child: const Icon(
                          Icons.send,
                          color: AppColors.mutedWhite,
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getWriteCommentTitle(BuildContext context) {
    return SizedBox(
      height: 32,
      child: replyCommentModel == null
          ? Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Write a Comment",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: AppColors.mutedWhite),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: AppColors.mutedWhite),
                    children: <TextSpan>[
                      const TextSpan(
                        text: "Replying to ",
                      ),
                      TextSpan(
                        text: "@${replyCommentModel!.username}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: AppColors.mutedWhite),
                      )
                    ],
                  ),
                ),
                InkWell(
                    onTap: () {
                      clearReplyModel();
                    },
                    child: const Icon(
                      Icons.close_outlined,
                      size: 24,
                      color: Colors.black87,
                    )),
              ],
            ),
    );
  }

  Widget _getCommentButton() {
    return Container(
      alignment: Alignment.bottomRight,
      child: commentCreateLoading
          ? const CircularProgressIndicator()
          : AppButton(
              label: replyCommentModel == null ? "Send" : "Reply",
              color: AppColors.black4,
              onPressed: () {
                createComment(
                  content: commentController.text,
                  parentId: replyCommentModel?.commentIt,
                );
              },
            ),
    );
  }
}
