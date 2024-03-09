import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/constants/enums.dart';
import 'package:flutter/material.dart';

class UserInfoDropdownItem extends StatefulWidget {
  const UserInfoDropdownItem(
      {super.key,
      required this.label,
      required this.onChanged,
      this.item,
      required this.isEditing,
      required this.info});

  final String label;
  final Function(Departments?) onChanged;
  final Departments? item;
  final bool isEditing;
  final String info;

  @override
  State<UserInfoDropdownItem> createState() => _UserInfoDropdownItemState();
}

class _UserInfoDropdownItemState extends State<UserInfoDropdownItem> {
  List<String> conditions = ['Used', 'Brand New', 'Field Tested']; //TODO
  List<String> categories = ['Book', 'Clothes', 'Electronics']; //TODO

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.label,
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
                color: widget.isEditing
                    ? AppColors.bilkentBlue
                    : Colors.transparent),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Center(
            child: widget.isEditing
                ? DropdownButtonHideUnderline(
                  child: DropdownButton<Departments>(
                      menuMaxHeight: 300,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      iconSize: 40,
                      dropdownColor: AppColors.secondary,
                      value: widget.item,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: AppColors.mutedWhite,
                              fontWeight: FontWeight.w500),
                      items: Departments.values.map((entry) {
                        return DropdownMenuItem<Departments>(
                          value: entry,
                          child: Text(entry.name),
                        );
                      }).toList(),
                      hint: Text(
                        widget.label,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                                color: Color(0xff99999a),
                                fontWeight: FontWeight.w500),
                      ),
                      onChanged: widget.onChanged),
                )
                : SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.info,
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
