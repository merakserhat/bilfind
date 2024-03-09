import 'package:bilfind_app/constants/app_constants.dart';
import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/comment_model.dart';
import 'package:bilfind_app/screens/post_detail/post_detail_screen.dart';
import 'package:bilfind_app/screens/post_detail/widgets/comment_answer_item.dart';
import 'package:bilfind_app/screens/post_detail/widgets/comment_section.dart';
import 'package:bilfind_app/utils/util_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class CommentListItem extends StatefulWidget {
  const CommentListItem({
    Key? key,
    required this.commentModel,
    this.answers = const [],
    required this.onReplyClicked,
  }) : super(key: key);

  final CommentModel commentModel;
  final List<CommentModel> answers;
  final Function(ReplyCommentModel) onReplyClicked;

  @override
  State<CommentListItem> createState() => _CommentListItemState();
}

class _CommentListItemState extends State<CommentListItem> {
  bool showAnswers = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.subText)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: onSeeOthersProfile,
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          widget.commentModel.ownerPhoto ??
                              AppConstants.defaultProfilePhoto,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w300,
                            color: AppColors.mutedWhite),
                        children: <TextSpan>[
                          TextSpan(
                              text: widget.commentModel.ownerName + " ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: AppColors.white)),
                          TextSpan(
                            text: widget.commentModel.content,
                          ),
                          TextSpan(
                              text:
                                  "\n${UtilFunctions.formatTimeElapsed(widget.commentModel.createdAt)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(color: AppColors.subText)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              showAnswers = !showAnswers;
                            });
                          },
                          child: Text(
                              showAnswers
                                  ? "--- Hide Replies"
                                  : "--- See ${widget.answers.length} answer${widget.answers.length > 1 ? "s" : ""}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(color: AppColors.subText)),
                        ),
                        InkWell(
                          onTap: () {
                            widget.onReplyClicked(ReplyCommentModel(
                                commentIt: widget.commentModel.id,
                                username: widget.commentModel.ownerName));
                          },
                          child: Text("Reply",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(color: AppColors.subText)),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...(!showAnswers
              ? []
              : widget.answers.map(
                  (answer) => CommentAnswerListItem(commentModel: answer))),
        ],
      ),
    );
  }

  void onSeeOthersProfile() {
    context.go("/user/${widget.commentModel.userId}");
  }
}
