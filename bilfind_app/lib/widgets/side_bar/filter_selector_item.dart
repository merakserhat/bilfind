import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/constants/enums.dart';
import 'package:flutter/material.dart';

class FilterSelectorItem extends StatelessWidget {
  const FilterSelectorItem(
      {Key? key,
      required this.isSelected,
      required this.name,
      required this.onSelectionChange,
      required this.postType})
      : super(key: key);

  final bool isSelected;
  final String name;
  final String postType;
  final Function(String, bool) onSelectionChange;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelectionChange(postType, !isSelected);
      },
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.black4,
            ),
            child: isSelected
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.mutedWhite),
                  )
                : Container(),
          ),
          const SizedBox(width: 8),
          Text(name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: AppColors.mutedWhite))
        ],
      ),
    );
  }
}
