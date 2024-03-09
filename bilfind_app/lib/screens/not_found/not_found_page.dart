import 'package:bilfind_app/models/post_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/search_filter_model.dart';
import 'package:bilfind_app/screens/post_detail/widgets/post_item.dart';
import 'package:bilfind_app/services/auth_service.dart';
import 'package:bilfind_app/services/post_service.dart';
import 'package:bilfind_app/utils/routing/custom_route.dart';
import 'package:bilfind_app/widgets/app_bar/authenticated_app_bar.dart';
import 'package:bilfind_app/widgets/custom_wrap.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:bilfind_app/widgets/search_bar.dart';
import 'package:bilfind_app/widgets/side_bar/filter_side_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';

class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({Key? key}) : super(key: key);
  static CustomRoute customRoute = CustomRoute(route: "/404");

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  @override
  void initState() {
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
        child: const Center(
          child: Text("404"),
        ),
      ),
    );
  }
}
