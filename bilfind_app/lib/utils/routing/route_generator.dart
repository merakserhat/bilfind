import 'dart:js';

import 'package:bilfind_app/models/conversation_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/screens/auth/auth_screen.dart';
import 'package:bilfind_app/screens/chat/chat_screen.dart';
import 'package:bilfind_app/screens/create_post/create_post_screen.dart';
import 'package:bilfind_app/screens/not_found/not_found_page.dart';
import 'package:bilfind_app/screens/post_detail/post_detail_screen.dart';
import 'package:bilfind_app/screens/profile_page/profile_page_screen.dart';
import 'package:bilfind_app/screens/reported_posts/user_reported_posts_screen.dart';
import 'package:bilfind_app/screens/search/search_screen.dart';
import 'package:bilfind_app/screens/settings/settings_screen.dart';
import 'package:bilfind_app/screens/splash/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class RouteGenerator {
  final String splashRoute = "/";
  final String searchRoute = "/search";
  final String profileRoute = "/user/:userId";
  final String settingsRoute = "/settings";
  final String detailRoute = "/detail/:postId";
  final String createRoute = "/create";
  final String authRoute = "/auth";
  final String notFoundRoute = "/404";
  final String editRoute = "/post/edit/:postId";
  final String chatRoute = "/chat";
  final String myReportsRoute = "/reports";

  // final String authRoute = ""

  getRouter() {
    return GoRouter(
      initialLocation: searchRoute,
      routes: [
        GoRoute(
            path: splashRoute,
            builder: (context, state) {
              return const SplashScreen();
            }),
        GoRoute(
          path: detailRoute,
          builder: (context, state) => PostDetailScreen(
            postId: state.pathParameters["postId"],
          ),
        ),
        GoRoute(
          path: authRoute,
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: searchRoute,
          builder: (context, state) {
            return SearchScreen(
              key: UniqueKey(),
            );
          },
        ),
        GoRoute(
          path: notFoundRoute,
          builder: (context, state) => const NotFoundScreen(),
        ),
        GoRoute(
          path: editRoute,
          builder: (context, state) => CreatePostScreen(
            postId: state.pathParameters["postId"],
          ),
        ),
        GoRoute(
          path: createRoute,
          builder: (context, state) => const CreatePostScreen(),
        ),
        GoRoute(
          path: chatRoute,
          builder: (context, state) {
            ConversationModel? conversationModel;
            if (state.extra != null) {
              conversationModel = state.extra as ConversationModel;
            }
            return ChatScreen(
              conversationModel: conversationModel,
            );
          },
        ),
        GoRoute(
          path: profileRoute,
          builder: (context, state) => ProfilePageScreen(
            key: UniqueKey(),
            userId: state.pathParameters["userId"] as String,
          ),
        ),
        GoRoute(
          path: settingsRoute,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: myReportsRoute,
          builder: (context, state) => const UserReportedPostsScreen(),
        )
      ],
    );
  }
}
