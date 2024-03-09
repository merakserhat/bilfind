import 'package:bilfind_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class UserInfoItem extends StatelessWidget {
  const UserInfoItem({
    super.key,
    required this.label,
    required this.info,
    this.isEditing = false,
    this.textEditingController,
  });

  final String label;
  final String info;
  final bool isEditing;
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColors.subText,
              ),
        ),
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.black4,
            border: Border.all(
                width: 2,
                color: isEditing ? AppColors.bilkentBlue : Colors.transparent),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Center(
            child: isEditing
                ? SizedBox(
                    height: double.infinity,
                    child: Center(
                      child: TextField(
                        controller: textEditingController,
                        textAlignVertical: TextAlignVertical.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: AppColors.mutedWhite),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          filled: true,
                          fillColor: Colors.transparent,
                          isDense: true,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: Text(
                      info,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: AppColors.mutedWhite),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12)
      ],
    );
  }
}
