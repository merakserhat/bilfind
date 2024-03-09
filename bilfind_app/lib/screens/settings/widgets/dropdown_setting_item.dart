import 'package:bilfind_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class DropdownSettingItem extends StatefulWidget {
  const DropdownSettingItem(
      {super.key,
      required this.settingTitle,
      required this.isOpen,
      required this.choice});

  final String settingTitle;
  final String choice;
  final bool isOpen;

  @override
  State<DropdownSettingItem> createState() => _DropdownSettingItemState();
}

class _DropdownSettingItemState extends State<DropdownSettingItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.settingTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColors.mutedWhite)),
            Text(
              widget.choice,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: AppColors.black6),
            )
          ],
        ),
        Icon(
          !widget.isOpen ? Icons.arrow_drop_down : Icons.arrow_drop_up,
          color: AppColors.mutedWhite,
          size: 32,
        )
      ],
    );
  }
}
