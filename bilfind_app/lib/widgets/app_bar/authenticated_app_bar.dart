import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/screens/auth/auth_screen.dart';
import 'package:bilfind_app/screens/search/search_screen.dart';
import 'package:bilfind_app/services/auth_service.dart';
import 'package:bilfind_app/services/local_service.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/widgets/app_bar/widgets/create_post_button.dart';
import 'package:bilfind_app/widgets/app_bar/widgets/messages_button.dart';
import 'package:bilfind_app/widgets/app_bar/widgets/my_profile_button.dart';
import 'package:bilfind_app/widgets/app_bar/widgets/notifications_button.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:bilfind_app/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthenticatedAppBar extends StatefulWidget {
  const AuthenticatedAppBar(
      {Key? key, this.searchBar, this.userRetrieved = true})
      : super(key: key);
  final CustomSearchBar? searchBar;
  final bool userRetrieved;

  @override
  State<AuthenticatedAppBar> createState() => _AuthenticatedAppBarState();
}

class _AuthenticatedAppBarState extends State<AuthenticatedAppBar> {
  bool open = false;
  final double navBarClosedHeight = 60;

  get navBarOpenHeight {
    if (widget.searchBar == null) {
      return 100;
    }

    return 140;
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
        desktop: getDesktopLayout(),
        tablet: getDesktopLayout(),
        mobile: getMobileLayout());
  }

  Widget getMobileLayout() {
    return AnimatedContainer(
      height: open ? navBarOpenHeight : navBarClosedHeight,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white, width: 0),
        ),
        color: AppColors.primary,
      ),
      duration: const Duration(milliseconds: 300),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: navBarClosedHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: onHomeClicked,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        SizedBox(
                            width: 32,
                            height: 32,
                            child:
                                Image.asset("assets/images/bilkent_logo.png")),
                        const SizedBox(width: 8),
                        Text(
                          "BilFind",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        open = !open;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(
                        open
                            ? Icons.arrow_drop_up_outlined
                            : Icons.arrow_drop_down_sharp,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            !open ? Container() : getNarrowLayoutBottom(),
          ],
        ),
      ),
    );
  }

  Widget getNarrowLayout() {
    return InkWell(
      onTap: () {
        setState(() {
          open = !open;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Icon(
          open ? Icons.arrow_drop_up_outlined : Icons.arrow_drop_down_sharp,
          size: 24,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget getDesktopLayout() {
    return Container(
      height: navBarClosedHeight,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white, width: 0),
        ),
        color: AppColors.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onHomeClicked,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 8),
                SizedBox(
                    width: 32,
                    height: 32,
                    child: Image.asset("assets/images/bilkent_logo.png")),
                const SizedBox(width: 8),
                Text(
                  "BilFind",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
                                const SizedBox(width: 8),

              ],
            ),
          ),
          widget.searchBar == null
              ? Container()
              : Expanded(
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: widget.searchBar!,
                )),
          Row(
            children: [
              const MessagesButton(),
              const SizedBox(width: 8),
              const CreatePostButton(),
              const SizedBox(width: 12),
              widget.userRetrieved
                  ? const MyProfileButton()
                  : const CircularProgressIndicator(),
              const SizedBox(width: 32),
            ],
          )
        ],
      ),
    );
  }

  Widget getNarrowLayoutBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    MessagesButton(),
                    SizedBox(width: 8),
                    NotificationsButton(),
                  ],
                ),
                Row(
                  children: [
                    const CreatePostButton(),
                    const SizedBox(width: 8),
                    widget.userRetrieved
                        ? const MyProfileButton()
                        : const CircularProgressIndicator(),
                  ],
                ),
              ],
            ),
          ),
          widget.searchBar == null ? Container() : widget.searchBar!
        ],
      ),
    );
  }

  void onHomeClicked() {
    if (widget.searchBar == null) {
      context.go(RouteGenerator().searchRoute);
    }
  }
}
