import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/screens/auth/auth_screen.dart';
import 'package:bilfind_app/screens/not_found/not_found_page.dart';
import 'package:bilfind_app/screens/post_detail/post_detail_screen.dart';
import 'package:bilfind_app/screens/splash/splash_screen.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bilfind',
      theme: AppThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: RouteGenerator().getRouter(),
    );
  }
}
