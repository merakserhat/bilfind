import 'package:bilfind_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class PostTypeChoiceButton extends StatelessWidget {
  const PostTypeChoiceButton(
      {super.key,
      required this.type,
      required this.image,
      required this.onSelected});

  final String type;
  final String image;
  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelected(type),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.secondary),
        child: Column(
          children: [
            ClipRRect(
              child: Container(
                width: 100, 
                height: 100,
                color: AppColors.secondary, 
                child: Image.network(image)
              ),
            ),
            const SizedBox(height: 20),
            Text(type, style: TextStyle(color: Colors.white)),
            
          ],
        ),
      ),
    );
  }
}
