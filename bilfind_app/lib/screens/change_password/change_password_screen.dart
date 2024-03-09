import 'package:bilfind_app/screens/change_password/widgets/change_password_widget.dart';
import 'package:bilfind_app/widgets/app_bar/authenticated_app_bar.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: ((Theme.of(context).brightness == Brightness.dark)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            .copyWith(
          statusBarColor: Theme.of(context).colorScheme.background,
        ),
        child: Responsive(
          mobile: getMobileLayout(),
          tablet: getMobileLayout(),
          desktop: getDesktopLayout(),
        ),
      ),
    );
  }

  Widget getMobileLayout() {
    return const Column(
      children: [
        AuthenticatedAppBar(),
        Expanded(
          child: ChangePasswordWidget(),
        ),
      ],
    );
  }

  Widget getDesktopLayout() {
    return Column(
      children: [
        const AuthenticatedAppBar(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: ChangePasswordWidget()),
              Expanded(
                child: Image.asset(
                  "assets/images/auth_image.png",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}