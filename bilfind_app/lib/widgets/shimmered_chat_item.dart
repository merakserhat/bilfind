import 'package:flutter/material.dart';

class ShimmeredChatItem extends StatelessWidget {
  const ShimmeredChatItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 72,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 32,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 12.0,
                          color: Colors.white,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 12.0,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: double.infinity,
                    height: 12.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
