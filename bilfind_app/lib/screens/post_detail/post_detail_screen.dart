import 'package:bilfind_app/models/comment_model.dart';
import 'package:bilfind_app/models/post_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/response/get_post_detail_response.dart';
import 'package:bilfind_app/screens/post_detail/widgets/comment_section.dart';
import 'package:bilfind_app/screens/post_detail/widgets/post_item.dart';
import 'package:bilfind_app/screens/post_detail/widgets/write_comment_section.dart';
import 'package:bilfind_app/services/post_service.dart';
import 'package:bilfind_app/utils/routing/custom_route.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/utils/util_functions.dart';
import 'package:bilfind_app/widgets/app_bar/authenticated_app_bar.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_theme.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({Key? key, this.postId}) : super(key: key);

  final String? postId;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool getDataRan = false;

  late List<CommentModel> comments;
  late PostModel postModel;
  bool dataLoading = true;
  bool commentCreateLoading = false;
  ReplyCommentModel? replyCommentModel;
  String? error;
  final TextEditingController commentController = TextEditingController();
  final Key postItemKey = Key(UtilFunctions.generateRandomString());

  getData({bool skipAuthCheck = false}) async {
    if (!skipAuthCheck) {
      if (getDataRan) {
        return;
      }
      setState(() {
        getDataRan = true;
      });

      bool userRetrieved = await Program().retrieveUser();

      if (!userRetrieved) {
        return context.go(RouteGenerator().authRoute);
      }
    }

    String? postId = widget.postId;

    if (postId == null) {
      return;
    }

    GetPostDetailResponse? getPostDetailResponse =
        await PostService.getPostDetail(postId!);

    if (getPostDetailResponse != null) {
      comments = getPostDetailResponse.comments;
      postModel = getPostDetailResponse.postModel;
      setState(() {
        dataLoading = false;
      });
    } else {
      setState(() {
        dataLoading = false;
        error =
            "Something went wrong while getting post details.\nPlease try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: ((Theme.of(context).brightness == Brightness.dark)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            .copyWith(
          statusBarColor: Theme.of(context).colorScheme.background,
        ),
        child: dataLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mutedWhite,
                ),
              )
            : Responsive(
                mobile: _getMobileLayout(),
                tablet: _getMobileLayout(),
                desktop: _getDesktopLayout(),
              ),
      ),
    );
  }

  Widget _getMobileLayout() {
    return Column(
      children: [
        const AuthenticatedAppBar(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColors.backgroundColor,
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      PostItem(
                        postModel: postModel,
                        isDetail: true,
                      ),
                      _getCommentSection(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: WriteCommentSection(
                    commentController: commentController,
                    commentCreateLoading: commentCreateLoading,
                    replyCommentModel: replyCommentModel,
                    createComment: createComment,
                    clearReplyModel: clearReplyModel,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getDesktopLayout() {
    return Column(
      children: [
        const AuthenticatedAppBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              key: postItemKey,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    key: postItemKey,
                    flex: 7,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 800),
                      child: PostItem(
                        postModel: postModel,
                        isDetail: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 3,
                    child: Container(
                      height: 800,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: AppColors.black3,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: _getCommentSection()),
                          WriteCommentSection(
                            commentController: commentController,
                            commentCreateLoading: commentCreateLoading,
                            replyCommentModel: replyCommentModel,
                            createComment: createComment,
                            clearReplyModel: clearReplyModel,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _getCommentSection() {
    return dataLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : error != null
            ? Text(
                error!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.red),
              )
            : CommentSection(
                comments: comments,
                createComment: createComment,
                commentCreateLoading: commentCreateLoading,
                replyClicked: (ReplyCommentModel commentModel) {
                  setState(() {
                    replyCommentModel = commentModel;
                  });
                },
              );
  }

  createComment({required String content, String? parentId}) async {
    if (content.isEmpty) {
      return;
    }

    setState(() {
      commentCreateLoading = true;
    });
    bool result =
        await PostService.createComment(postModel.id, content, parentId);
    if (result) {
      // TODO: burada alttan uyarı göster error için
    }
    setState(() {
      commentCreateLoading = false;
      // dataLoading = true;
      commentController.text = "";
    });
    getData(skipAuthCheck: true);
  }

  void clearReplyModel() {
    setState(() {
      replyCommentModel = null;
    });
  }
}

class ReplyCommentModel {
  final String commentIt;
  final String username;

  ReplyCommentModel({required this.commentIt, required this.username});
}
