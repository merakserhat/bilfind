import 'dart:html';

import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/post_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/response/get_user_posts_response.dart';
import 'package:bilfind_app/screens/admin_panel/admin_panel_screen.dart';
import 'package:bilfind_app/screens/create_post/create_post_screen.dart';
import 'package:bilfind_app/screens/profile_page/widgets/profile_page_loading_shimmer.dart';
import 'package:bilfind_app/screens/profile_page/widgets/user_posts_section.dart';
import 'package:bilfind_app/screens/reported_posts/user_reported_posts_screen.dart';
import 'package:bilfind_app/screens/search/widgets/search_loading_shimmer.dart';
import 'package:bilfind_app/screens/settings/settings_screen.dart';
import 'package:bilfind_app/services/post_service.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/widgets/app_button.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePostsSection extends StatefulWidget {
  const ProfilePostsSection(
      {Key? key, required this.isOwnUser, required this.userId})
      : super(key: key);

  final bool isOwnUser;
  final String userId;

  @override
  State<ProfilePostsSection> createState() => _ProfilePostsSectionState();
}

class _ProfilePostsSectionState extends State<ProfilePostsSection> {
  bool isMyPostActive = true;
  late List<PostModel> ownPosts;
  late List<PostModel> favoritePosts;
  bool postsAreLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    GetUserPostsResponse? getUserPostsResponse =
        await PostService.getUserPosts(widget.userId);

    if (getUserPostsResponse != null) {
      ownPosts = getUserPostsResponse.userPosts;
      favoritePosts = getUserPostsResponse.favoritePosts;
      setState(() {
        postsAreLoading = false;
      });
    } else {
      setState(() {
        postsAreLoading = false;
        error = "Something went wrong while getting posts.\nPlease try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.primary,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AppButton(
                    customPadding: EdgeInsets.symmetric(
                        vertical: 9,
                        horizontal: Responsive.isMobile(context) ? 28 : 45),
                    label: widget.isOwnUser ? "My Posts" : "Posts",
                    color: isMyPostActive
                        ? AppColors.mutedWhite
                        : AppColors.black4,
                    onPressed: () {
                      if (!isMyPostActive) {
                        setState(() {
                          isMyPostActive = true;
                        });
                      }
                    },
                    textColor: !isMyPostActive
                        ? AppColors.mutedWhite
                        : AppColors.black4,
                  ),
                  const SizedBox(width: 8),
                  widget.isOwnUser
                      ? AppButton(
                          customPadding: EdgeInsets.symmetric(
                              vertical: 9,
                              horizontal:
                                  Responsive.isMobile(context) ? 28 : 45),
                          label: "Favorites",
                          textColor: isMyPostActive
                              ? AppColors.mutedWhite
                              : AppColors.black4,
                          color: !isMyPostActive
                              ? AppColors.mutedWhite
                              : AppColors.black4,
                          onPressed: () {
                            if (isMyPostActive) {
                              setState(() {
                                isMyPostActive = false;
                              });
                            }
                          },
                        )
                      : Container()
                ],
              ),
              Row(
                children: [
                  Program().userModel!.isAdmin &&
                          widget.isOwnUser &&
                          !Responsive.isMobile(context)
                      ? AppButton(
                          label: "Admin Panel",
                          textColor: AppColors.mutedWhite,
                          color: AppColors.black4,
                          onPressed: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => const AdminPanelScreen()));
                          },
                        )
                      : Container(),
                  const SizedBox(
                    width: 8,
                  ),
                  widget.isOwnUser
                      ? InkWell(
                          child: const Icon(
                            Icons.settings,
                            color: AppColors.mutedWhite,
                            size: 32,
                          ),
                          onTap: () {
                            context.go(RouteGenerator().settingsRoute);
                          },
                        )
                      : Container(),
                ],
              )
            ],
          ),
          Program().userModel!.isAdmin &&
                  widget.isOwnUser &&
                  Responsive.isMobile(context)
              ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppButton(
                      customPadding: const EdgeInsets.symmetric(vertical: 9, horizontal: 18),
                      label: "Admin Panel",
                      textColor: AppColors.mutedWhite,
                      color: AppColors.black4,
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (_) => const AdminPanelScreen()));
                      },
                    ),
                ),
              )
              : Container(),
          const SizedBox(height: 24),
          Container(
            child: postsAreLoading
                ? const SizedBox(
                    height: 800,
                    child: ProfilePageLoadingShimmer(),
                  )
                : error != null
                    ? Text(
                        error!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.red),
                      )
                    : UserPostsSection(
                        userModel: Program().userModel!,
                        isMyPostActive: isMyPostActive,
                        userPosts: ownPosts,
                        favPosts: favoritePosts,
                      ),
          )
        ],
      ),
    );
  }
}
