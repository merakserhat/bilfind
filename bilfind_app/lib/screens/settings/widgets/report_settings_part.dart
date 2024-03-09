import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/screens/change_password/change_password_screen.dart';
import 'package:bilfind_app/screens/reported_posts/user_reported_posts_screen.dart';
import 'package:bilfind_app/screens/settings/widgets/setting_item.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportSettingsPart extends StatefulWidget {
  const ReportSettingsPart({super.key});

  @override
  State<ReportSettingsPart> createState() => _ReportSettingsPartState();
}

class _ReportSettingsPartState extends State<ReportSettingsPart> {
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
            : const SizedBox(width: 12),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Report Settings",
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
                child:
                    SettingItem(settingTitle: "My Reports", onTap: onMyReports),
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

  void onMyReports() {
    context.go(RouteGenerator().myReportsRoute);
  }
}
