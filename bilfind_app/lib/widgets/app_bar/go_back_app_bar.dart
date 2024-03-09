import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/screens/search/search_screen.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/widgets/app_bar/widgets/go_back_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoBackAppBar extends StatelessWidget {
  const GoBackAppBar({super.key, required this.onPop});

  final double navBarClosedHeight = 60;
  final VoidCallback onPop;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.primary,
        width: double.infinity,
        height: navBarClosedHeight,
        child: Row(
          children: [
            GoBackButton(onPop: onPop),
            InkWell(
              onTap: () {
                context.go(RouteGenerator().searchRoute);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Image.asset(
                      "assets/images/bilkent_logo.png",
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "BilFind",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
