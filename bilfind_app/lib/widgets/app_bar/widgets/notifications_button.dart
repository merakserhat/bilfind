import 'package:flutter/material.dart';

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const InkWell(
      child: SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: Icon(
            Icons.notifications,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
