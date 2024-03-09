import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/screens/create_post/create_post_screen.dart';
import 'package:bilfind_app/screens/post_detail/post_detail_screen.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatePostButton extends StatelessWidget {
  const CreatePostButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go(RouteGenerator().createRoute);
      },
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.secondary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(
              Icons.photo_camera_rounded,
              size: 24,
              color: Colors.white,
            ),
            SizedBox(width: 4),
            Text(
              "Create",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
