import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DepartmentFilter extends StatefulWidget {
  const DepartmentFilter(
      {super.key,
      required this.label,
      required this.onChanged,
      this.selectedDepartment});

  final Function(Departments?) onChanged;
  final String label;
  final Departments? selectedDepartment;

  @override
  State<DepartmentFilter> createState() => _DepartmentFilterState();
}

class _DepartmentFilterState extends State<DepartmentFilter> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.label,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: AppColors.mutedWhite),
      ),
      Container(
        height: 44,
        decoration: BoxDecoration(
            color: AppColors.black4,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.transparent, width: 1)),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        width: double.infinity,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Departments>(
              menuMaxHeight: 300,
              iconSize: 20,
              dropdownColor: AppColors.black4,
              value: widget.selectedDepartment,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.mutedWhite, fontWeight: FontWeight.w500),
              items: Departments.values.map((entry) {
                return DropdownMenuItem<Departments>(
                  value: entry,
                  child: Text(entry.name),
                );
              }).toList(),
              hint: Text(
                widget.label,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColors.subText, fontWeight: FontWeight.w500),
              ),
              onChanged: widget.onChanged),
        ),
      ),
      const SizedBox(height: 8),
    ]);
  }
}
