import 'package:bilfind_app/constants/app_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PostPopup extends StatefulWidget {
  const PostPopup({
    Key? key,
    required this.onReportClicked,
    required this.onAddFavoritesClicked,
    required this.onSharePostClicked,
    required this.onViewAccountClicked,
    required this.onCancelClicked,
    required this.isFav,
    required this.isMyPost,
    required this.onEditPostClicked,
    required this.onDeletePostClicked,
  }) : super(key: key);

  final VoidCallback onReportClicked;
  final VoidCallback onAddFavoritesClicked;
  final VoidCallback onSharePostClicked;
  final VoidCallback onViewAccountClicked;
  final VoidCallback onCancelClicked;
  final VoidCallback onEditPostClicked;
  final VoidCallback onDeletePostClicked;
  final bool isFav;
  final bool isMyPost;

  @override
  State<PostPopup> createState() => _PostPopupState();
}

class _PostPopupState extends State<PostPopup> {
  List<PostPopupItemModel> buttons = [];
  PostPopupItemModel? hoverItem;

  @override
  void initState() {
    super.initState();

    buttons = [
      PostPopupItemModel(
          text: "Report",
          onTap: widget.onReportClicked,
          textColor: Colors.red,
          firstElement: true),
      PostPopupItemModel(
          text: widget.isFav ? "Remove from Favorites" : "Add to Favorites",
          onTap: widget.onAddFavoritesClicked),
      PostPopupItemModel(text: "Share", onTap: widget.onSharePostClicked),
    ];

    if (widget.isMyPost) {
      buttons.add(
        PostPopupItemModel(text: "Edit Post", onTap: widget.onEditPostClicked),
      );
      buttons.add(
        PostPopupItemModel(
            text: "Delete Post",
            onTap: widget.onDeletePostClicked,
            textColor: Colors.red),
      );
    } else {
      buttons.add(
        PostPopupItemModel(
            text: "View Account", onTap: widget.onViewAccountClicked),
      );
    }

    buttons.add(
      PostPopupItemModel(text: "Cancel", onTap: widget.onCancelClicked),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            width: MediaQuery.of(context).size.width - 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.black2,
              border: Border.all(color: AppColors.mutedWhite, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: buttons
                  .map(
                    (buttonModel) => InkWell(
                      onTap: buttonModel.onTap,
                      onHover: (value) {
                        if (value) {
                          setState(() {
                            hoverItem = buttonModel;
                          });
                        } else {
                          if (hoverItem == buttonModel) {
                            setState(() {
                              hoverItem = null;
                            });
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            border: buttonModel.firstElement
                                ? null
                                : const Border(
                                    top: BorderSide(
                                      color: AppColors.mutedWhite,
                                      width: 0,
                                    ),
                                  ),
                            color: hoverItem == buttonModel
                                ? Colors.white10
                                : Colors.transparent),
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            buttonModel.text,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: buttonModel.textColor),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class PostPopupItemModel extends Equatable {
  final String text;
  final VoidCallback onTap;
  final Color textColor;
  final bool firstElement;

  const PostPopupItemModel({
    required this.text,
    required this.onTap,
    this.textColor = AppColors.mutedWhite,
    this.firstElement = false,
  });

  @override
  List<Object?> get props => [text];
}
