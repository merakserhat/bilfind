import 'package:bilfind_app/widgets/app_bar/widgets/go_back_button.dart';
import 'package:bilfind_app/widgets/profile_photo.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar(
      {Key? key, required this.fullName, required this.imageUrl, this.onBack})
      : super(key: key);

  final String imageUrl;
  final String fullName;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Responsive.isMobile(context)
                ? Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: GoBackButton(onPop: onBack!))
                : Container(),
            Hero(
              tag: "CHAT_PROFILE_PHOTO",
              child: SizedBox(
                width: 36,
                height: 36,
                child: ProfilePhoto(imageUrl: imageUrl!),
              ),
            ),
            const SizedBox.square(dimension: 10),
            Text(fullName),
          ],
        ),
      ),
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}
