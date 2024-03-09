import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/screens/settings/widgets/account_settings_part.dart';
import 'package:bilfind_app/screens/settings/widgets/notification_settings_part.dart';
import 'package:bilfind_app/screens/settings/widgets/report_settings_part.dart';
import 'package:bilfind_app/widgets/app_bar/authenticated_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool userRetrieved = false;
  @override
  void initState() {
    super.initState();
    Program().retrieveUser().then((retrieved) {
      if (retrieved) {
        setState(() {
          userRetrieved = true;
        });
      } else {
        context.go("/auth");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthenticatedAppBar(
              userRetrieved: userRetrieved,
            ),
            const SizedBox(height: 80),
            const NotificationSettingsPart(),
            const SizedBox(height: 12),
            const AccountSettingsPart(),
            const SizedBox(height: 12),
            const ReportSettingsPart(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
