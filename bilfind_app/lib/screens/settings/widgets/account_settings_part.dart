import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/screens/auth/auth_screen.dart';
import 'package:bilfind_app/screens/change_password/change_password_screen.dart';
import 'package:bilfind_app/screens/reported_posts/user_reported_posts_screen.dart';
import 'package:bilfind_app/screens/settings/widgets/setting_item.dart';
import 'package:bilfind_app/services/auth_service.dart';
import 'package:bilfind_app/services/local_service.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/widgets/popups/warning_popup.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountSettingsPart extends StatefulWidget {
  const AccountSettingsPart({super.key});

  @override
  State<AccountSettingsPart> createState() => _AccountSettingsPartState();
}

class _AccountSettingsPartState extends State<AccountSettingsPart> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        !Responsive.isMobile(context)
            ? Flexible(
                flex: 3,
                child: Container(
                  color: AppColors.backgroundColor,
                ))
            : SizedBox(width: 12),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Account Settings",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: AppColors.mutedWhite)),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SettingItem(
                      settingTitle: "Change Password",
                      onTap: onChangePassword,
                    ),
                    Container(
                      height: 0.5,
                      color: AppColors.mutedWhite,
                    ),
                    SettingItem(
                      settingTitle: "Logout",
                      onTap: onLogout,
                    ),
                    Container(
                      height: 0.5,
                      color: AppColors.mutedWhite,
                    ),
                    SettingItem(
                      settingTitle: "Delete Account",
                      onTap: onDeleteAccountClicked,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        !Responsive.isMobile(context)
            ? Flexible(
                flex: 3,
                child: Container(
                  color: AppColors.backgroundColor,
                ))
            : const SizedBox(width: 12),
      ],
    );
  }

  void onChangePassword() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (_) => const ChangePasswordScreen()));
  }

  void onDeleteAccountClicked() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WarningPopup(
          title: "Delete Account",
          content: "Are you sure you want to delete your account?",
          approveLabel: "Delete",
          onApproved: onDeleteAccountApproved,
          isAsync: true,
        );
      },
    );
  }

  void onDeleteAccountApproved() async {
    bool result = await AuthService.deleteUser();

    if (result) {
      context.go(RouteGenerator().authRoute);
      await Future.delayed(const Duration(milliseconds: 300));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Your account successfully deleted!",
          ),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 1300),
        ),
      );
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
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

  void onLogout() {
    context.go(RouteGenerator().authRoute);
    LocalService().deleteToken();
  }
}
