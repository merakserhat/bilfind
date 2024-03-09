import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyProfileButton extends StatelessWidget {
  const MyProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go("/user/${Program().userModel!.id}");
      },
      child: Container(
        height: 33,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.secondary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(
              Icons.person_rounded,
              size: 24,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: Stack(
                children: [
                  Positioned(
                    top: 2,
                    child: Text(
                      Program().userModel!.name,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    child: Text(
                      Program().userModel!.email,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 8),
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
