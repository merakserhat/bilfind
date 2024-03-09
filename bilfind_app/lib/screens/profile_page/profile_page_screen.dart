import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/user_model.dart';
import 'package:bilfind_app/screens/profile_page/widgets/information_section.dart';
import 'package:bilfind_app/screens/profile_page/widgets/profile_posts_section.dart';
import 'package:bilfind_app/services/user_service.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/widgets/app_bar/authenticated_app_bar.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ProfilePageScreen extends StatefulWidget {
  const ProfilePageScreen({super.key, required this.userId});

  final String userId;

  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  UserModel? userModel;
  bool isOwnUser = true;

  @override
  void initState() {
    Program().retrieveUser().then((retrieved) {
      if (retrieved) {
        if (Program().userModel!.id == widget.userId) {
          setState(() {
            isOwnUser = true;
            userModel = Program().userModel;
          });
        } else {
          UserService.getUserModel(widget.userId).then((retrievedUser) {
            if (retrievedUser != null) {
              setState(() {
                isOwnUser = false;
                userModel = retrievedUser;
              });
            } else {
              context.go(RouteGenerator().notFoundRoute);
            }
          });
        }
      } else {
        context.go(RouteGenerator().authRoute);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: ((Theme.of(context).brightness == Brightness.dark)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            .copyWith(
          statusBarColor: Theme.of(context).colorScheme.background,
        ),
        child: userModel == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mutedWhite,
                ),
              )
            : SingleChildScrollView(
                child: Responsive(
                  mobile: getMobileView(),
                  tablet: getMobileView(),
                  desktop: getDesktopView(),
                ),
              ),
      ),
    );
  }

  Widget getMobileView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const AuthenticatedAppBar(),
          const SizedBox(height: 48),
          InformationSection(
            isOwnUser: isOwnUser,
            userModel: userModel!,
          ),
          const SizedBox(height: 24),
          ProfilePostsSection(
            userId: widget.userId,
            isOwnUser: isOwnUser,
          ),
        ],
      ),
    );
  }

  Widget getDesktopView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthenticatedAppBar(),
        const SizedBox(height: 48),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 24),
            Flexible(
              flex: 1,
              child: InformationSection(
                isOwnUser: isOwnUser,
                userModel: userModel!,
              ),
            ),
            const SizedBox(width: 24),
            Flexible(
                flex: 4,
                child: ProfilePostsSection(
                  userId: widget.userId,
                  isOwnUser: isOwnUser,
                )),
            const SizedBox(width: 24),
            
          ],
        ),
      ],
    );
  }
}
