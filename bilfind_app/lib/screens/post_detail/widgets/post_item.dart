import 'package:bilfind_app/constants/app_constants.dart';
import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/conversation_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/post_model.dart';
import 'package:bilfind_app/screens/post_detail/widgets/like_button.dart';
import 'package:bilfind_app/services/post_service.dart';
import 'package:bilfind_app/services/report_service.dart';
import 'package:bilfind_app/services/user_service.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/utils/util_functions.dart';
import 'package:bilfind_app/widgets/app_button.dart';
import 'package:bilfind_app/widgets/popups/post_popup.dart';
import 'package:bilfind_app/widgets/popups/warning_popup.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class PostItem extends StatefulWidget {
  const PostItem(
      {super.key,
      required this.postModel,
      this.isDetail = false,
      this.isAdminView = false,
      this.isUnderEvaluation = false});

  final PostModel postModel;
  final bool isDetail;
  final bool isAdminView;
  final bool isUnderEvaluation;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late final bool isMyPost;
  bool seeMore = false;
  bool popupOpen = false;
  bool deletePopupOpen = false;
  final double padding = 10;

  @override
  void initState() {
    super.initState();
    isMyPost = Program().userModel!.ownPostIds.contains(widget.postModel);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!widget.isDetail) {
          context.go("/detail/${widget.postModel.id}");
        }
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 300),
        //padding: const EdgeInsets.all(10.0), // BAKICAMI
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: AppColors.black3,
            border: Border.all(
                color: deletePopupOpen || popupOpen
                    ? AppColors.black6
                    : Colors.transparent,
                width: 2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: padding),
                      child: InkWell(
                        onTap: onSeeOthersProfile,
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.primary,
                          backgroundImage: NetworkImage(
                            widget.postModel.ownerPhoto ??
                                AppConstants.defaultProfilePhoto,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: onSeeOthersProfile,
                            child: Text(
                              widget.postModel.ownerName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 16,
                                    color: AppColors.mutedWhite,
                                  ),
                            ),
                          ),
                          Text(
                            widget.postModel.ownerDepartment,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: AppColors.mutedWhite,
                                ),
                          ),
                          Text(
                            "${UtilFunctions.formatTimeElapsed(widget.postModel.createdAt)}",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: AppColors.subText,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        _showPopupPanel(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(padding),
                        child: const Icon(
                          Icons.more_horiz,
                          color: AppColors.mutedWhite,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _getImagesSection(),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: padding),
                                    child: Container(
                                      width: 100,
                                      height: 32,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(12),
                                              bottomRight: Radius.circular(12)),
                                          color:
                                              Color.fromRGBO(77, 77, 255, 1)),
                                      child: Text(widget.postModel.type,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                fontSize: 16,
                                                color: AppColors.mutedWhite,
                                              )),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _getSecondSendMessageButton(),
                                      Container(
                                        padding:
                                            EdgeInsets.only(right: padding),
                                        child: LikeButton(
                                          favCount: widget.postModel.favCount,
                                          isFav: Program()
                                              .userModel!
                                              .favoritePostIds
                                              .contains(widget.postModel.id),
                                          favStateChanged: onFavStateChanged,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              widget.postModel.price != null
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                          top: 8, left: padding),
                                      child: Text(
                                        "${widget.postModel.price!} ₺",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                                fontSize: 18,
                                                color: AppColors.mutedWhite),
                                      ),
                                    )
                                  : Container(),
                              Container(
                                padding: EdgeInsets.only(left: padding),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.postModel.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          fontSize: 18,
                                          color: AppColors.mutedWhite),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: padding),
                          alignment: Alignment.topLeft,
                          child: Text(widget.postModel.content,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines:
                                  !seeMore || widget.postModel.isMock ? 4 : 99,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.subText,
                                  )),
                        ),
                        !seeMore && widget.isDetail
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    seeMore = true;
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("See more",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(color: AppColors.subText)),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            ),
            widget.isAdminView ||
                    Program().userModel!.id == widget.postModel.userId
                ? Container()
                : _getSendMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _getSecondSendMessageButton() {
    return widget.isDetail && widget.postModel.userId != Program().userModel!.id
        ? Row(
            children: [
              AppButton(
                  onPressed: onMessageSend,
                  disableResizeButton: true,
                  label: "SEND MESSAGE",
                  color: Color.fromRGBO(77, 77, 255, 1),
                  customPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
              Responsive.isMobile(context)
                  ? const SizedBox(width: 2)
                  : const SizedBox(
                      width: 12,
                    ),
            ],
          )
        : Container();
  }

  Widget _getSendMessageButton() {
    return widget.isDetail
        ? Container()
        : Container(
            padding: EdgeInsets.all(padding),
            width: double.infinity,
            child: AppButton(
              label: "Send Message",
              onPressed: onMessageSend,
              color: AppColors.black4,
            ),
          );
  }

  onMessageSend() {
    if (widget.postModel.userId != Program().userModel!.id) {
      //IMPORTANT: do not change the id. It is crucial
      ConversationModel mockConversation = ConversationModel(
          id: AppConstants.mockConvId,
          post: widget.postModel,
          ownerPhoto: widget.postModel.ownerPhoto,
          ownerName: widget.postModel.ownerName,
          ownerEmail: widget.postModel.ownerEmail,
          ownerId: widget.postModel.ownerUserId,
          ownerDepartment: widget.postModel.ownerDepartment,
          senderPhoto: Program().userModel!.profilePhoto,
          senderName:
              "${Program().userModel!.name} ${Program().userModel!.familyName}",
          senderEmail: Program().userModel!.email,
          senderId: Program().userModel!.id,
          senderDepartment: Program().userModel!.departmant,
          createdAt: DateTime.now(),
          status: "WAITING",
          messages: []);

      context.go(RouteGenerator().chatRoute, extra: mockConversation);
    }
  }

  onFavStateChanged(isFav) {
    UserService.changeFavPost(widget.postModel.id);

    if (Program().userModel!.favoritePostIds.contains(widget.postModel.id) &&
        !isFav) {
      Program().userModel!.favoritePostIds.remove(widget.postModel.id);
      setState(() {});
      return;
    }

    if (!Program().userModel!.favoritePostIds.contains(widget.postModel.id) &&
        isFav) {
      Program().userModel!.favoritePostIds.add(widget.postModel.id);
      setState(() {});
      return;
    }
  }

  _getImagesSection() {
    Widget images = Row(children: [
      ...widget.postModel.images
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(4.0),
              child: Builder(builder: (context) {
                Widget imageWidget = ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: SizedBox(
                    height: double.infinity,
                    child: Image.network(
                      e,
                      fit: BoxFit.cover,
                    ),
                  ),
                );

                if (widget.isDetail) {
                  return imageWidget;
                }
                return AspectRatio(
                  aspectRatio: 12 / 9,
                  child: imageWidget,
                );
              }),
            ),
          )
          .toList(),
      ...widget.postModel.mockImages!
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(4.0),
              child: Builder(builder: (context) {
                Widget imageWidget = ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: SizedBox(
                    height: double.infinity,
                    child: Image.memory(
                      e,
                      fit: BoxFit.cover,
                    ),
                  ),
                );

                if (widget.isDetail) {
                  return imageWidget;
                }
                return AspectRatio(
                  aspectRatio: 12 / 9,
                  child: imageWidget,
                );
              }),
            ),
          )
          .toList()
    ]);

    return (widget.postModel.isMock &&
                (widget.postModel.mockImages.isNotEmpty ||
                    widget.postModel.images.isNotEmpty)) ||
            (!widget.postModel.isMock && widget.postModel.images.isNotEmpty)
        ? Container(
            height: widget.isDetail ? 500 : 250,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: images,
            ),
          )
        : Container();
  }

  void _showPopupPanel(BuildContext context) {
    setState(() {
      popupOpen = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PostPopup(
          isFav: Program()
              .userModel!
              .favoritePostIds
              .contains(widget.postModel.id),
          isMyPost: Program().userModel?.email == widget.postModel.ownerEmail,
          onReportClicked: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WarningPopup(
                  title: "Report Post",
                  content: "Are you sure you want to report this post?",
                  approveLabel: "Report",
                  onApproved: onReportPostApproved,
                  isAsync: true,
                );
              },
            ).whenComplete(() {
              setState(() {
                deletePopupOpen = false;
              });
            });
          },
          onAddFavoritesClicked: () {
            onFavStateChanged(!Program()
                .userModel!
                .favoritePostIds
                .contains(widget.postModel.id));
            Navigator.of(context).pop();
          },
          onSharePostClicked: () {
            String url = Uri.base.origin + "/detail/${widget.postModel.id}";
            //TODO only WEB
            Clipboard.setData(ClipboardData(text: url)).then((value) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Post link is copied to clipboard.",
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(milliseconds: 1300),
                ),
              );
              Navigator.of(context).pop();
            });
          },
          onViewAccountClicked: () {
            context.go("user/" + widget.postModel.userId);
          },
          onCancelClicked: () {
            Navigator.of(context).pop();
          },
          onEditPostClicked: () {
            context.go("/post/edit/${widget.postModel.id}");
          },
          onDeletePostClicked: () {
            Navigator.of(context).pop();
            setState(() {
              deletePopupOpen = true;
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return WarningPopup(
                  title: "Delete Post",
                  content: "Are you sure you want to delete this post?",
                  approveLabel: "Delete",
                  onApproved: onDeletePostApproved,
                  isAsync: true,
                );
              },
            ).whenComplete(() {
              setState(() {
                deletePopupOpen = false;
              });
            });
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        popupOpen = false;
      });
    });
  }

  void onDeletePostApproved() async {
    bool result = await PostService.deletePost(widget.postModel.id);

    if (result) {
      Navigator.of(context).pop();
      context.go(RouteGenerator().searchRoute);
      await Future.delayed(const Duration(milliseconds: 300));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Your post successfully deleted!",
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

  void onReportPostApproved() async {
    bool result = await ReportService.reportPost(widget.postModel.id);

    if (result) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      await Future.delayed(const Duration(milliseconds: 300));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "You have successfully reported this post! You can see your reports from settings page.",
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

  void onSeeOthersProfile() {
    context.go("/user/${widget.postModel.ownerUserId}");
  }
}
