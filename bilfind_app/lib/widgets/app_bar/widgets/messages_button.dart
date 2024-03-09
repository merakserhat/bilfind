import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessagesButton extends StatelessWidget {
  const MessagesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go(RouteGenerator().chatRoute);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 32,
        height: 32,
        child: const Center(
          child: Icon(
            Icons.messenger_outlined,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
