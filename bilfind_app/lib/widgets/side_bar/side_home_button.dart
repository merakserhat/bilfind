import 'package:bilfind_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class SideHomeButton extends StatefulWidget {
  const SideHomeButton(
      {Key? key, required this.onTap, required this.isSelected})
      : super(key: key);

  final VoidCallback onTap;
  final bool isSelected;

  @override
  State<SideHomeButton> createState() => _SideHomeButtonState();
}

class _SideHomeButtonState extends State<SideHomeButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (val) {
        setState(() {
          isHover = val;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: !isHover ? Colors.transparent : AppColors.black4,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: widget.isSelected
                    ? AppColors.bilkentBlue
                    : AppColors.black4,
              ),
              child: const Center(
                child: Icon(
                  Icons.home,
                  color: AppColors.mutedWhite,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
              "See All",
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: AppColors.mutedWhite),
            ))
          ],
        ),
      ),
    );
  }
}
