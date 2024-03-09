import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({super.key, required this.onPop});

  final VoidCallback onPop;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPop,
      child: const  SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: Icon(
            Icons.arrow_back,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
