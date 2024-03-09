import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/comment_model.dart';
import 'package:bilfind_app/screens/post_detail/post_detail_screen.dart';
import 'package:bilfind_app/screens/post_detail/widgets/comment_box.dart';
import 'package:bilfind_app/screens/post_detail/widgets/comment_list_item.dart';
import 'package:bilfind_app/services/post_service.dart';
import 'package:bilfind_app/widgets/app_button.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/material.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({
    Key? key,
    required this.comments,
    required this.createComment,
    required this.commentCreateLoading,
    required this.replyClicked,
  }) : super(key: key);

  final List<CommentModel> comments;
  final Function({required String content, String? parentId}) createComment;
  final bool commentCreateLoading;
  final Function(ReplyCommentModel) replyClicked;

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: _getMobileLayout(),
        tablet: _getMobileLayout(),
        desktop: _getDesktopLayout(context));
  }

  Widget _getMobileLayout() {
    return Column(
      children: [
        _getCommentList(),
        const SizedBox(
          height: 60,
        )
      ],
    );
  }

  Widget _getDesktopLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getCommentsTitle(context),
        Expanded(
          child: SingleChildScrollView(child: _getCommentList()),
        ),
        const SizedBox(
          height: 4,
        ),
      ],
    );
  }

  Widget _getCommentsTitle(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Comment${comments.length > 1 ? "s" : ""} (${comments.length})",
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: AppColors.mutedWhite),
      ),
    );
  }

  Widget _getCommentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: comments.reversed
          .where((element) => element.parentId == null)
          .map((commentModel) => CommentListItem(
                onReplyClicked: (replyCommentModel) {
                  replyClicked(replyCommentModel);
                },
                commentModel: commentModel,
                answers: comments
                    .where((element) => element.parentId == commentModel.id)
                    .toList(),
              ))
          .toList(),
    );
  }
}
