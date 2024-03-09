import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/constants/enums.dart';
import 'package:flutter/material.dart';

class PostFormDropDownItem extends StatefulWidget {
  const PostFormDropDownItem({super.key, required this.label, required this.onChanged, this.item});

  final String label;
  final Function(Departments?) onChanged ;
  final Departments? item;

  @override
  State<PostFormDropDownItem> createState() => _PostFormDropDownItemState();
}

class _PostFormDropDownItemState extends State<PostFormDropDownItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Color(0xff99999a), width: 1)),
      margin: EdgeInsets.all(8),
      height: 60,
      width: double.infinity,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Departments>(
          menuMaxHeight: 300,
          padding: EdgeInsets.symmetric(horizontal: 8),
          iconSize: 40,
          dropdownColor: AppColors.secondary,
          value: widget.item,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppColors.mutedWhite, fontWeight: FontWeight.w500),
          items: Departments.values.map((entry) {
                return DropdownMenuItem<Departments>(
                  value: entry,
                  child: Text(entry.name),
                );
              }).toList(),
          hint: Text(
            widget.label,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Color(0xff99999a), fontWeight: FontWeight.w500),
          ),
          onChanged: widget.onChanged
        ),
      ),
    );
  }
}
