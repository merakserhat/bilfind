import "package:flutter/material.dart";

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Image.network(
        imageUrl, //TODO: default image

        fit: BoxFit.cover,
      ),
    );
  }
}
