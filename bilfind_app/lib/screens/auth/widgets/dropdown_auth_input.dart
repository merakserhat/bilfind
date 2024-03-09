import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownAuthInput extends StatefulWidget {
  const DropdownAuthInput({super.key, required this.label, required this.onChanged, this.selectedDepartment, this.validationError, this.serverError});

  final Function(Departments?) onChanged ;
  final String label;
  final Departments? selectedDepartment;
  final String? validationError;
  final String? serverError;

  @override
  State<DropdownAuthInput> createState() => _DropdownAuthInputState();
}

class _DropdownAuthInputState extends State<DropdownAuthInput> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: AppColors.inputBorderColor, fontWeight: FontWeight.w500),
        ),
        Container(
          height: 44,
          decoration: BoxDecoration(
              color: AppColors.silverGray,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColors.inputBorderColor, width: 1)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          width: double.infinity,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Departments>(
              iconSize: 20,
              dropdownColor: AppColors.silverGray,
              value: widget.selectedDepartment,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.black, fontWeight: FontWeight.w500),
              items: Departments.values.map((entry) {
                return DropdownMenuItem<Departments>(
                  value: entry,
                  child: Text(entry.name),
                );
              }).toList(),
              hint: Text(
                widget.label,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColors.inputBorderColor,
                    fontWeight: FontWeight.w500),
              ),
              onChanged: widget.onChanged
            ),
          ),
        ),
        const SizedBox(height: 8),
          widget.validationError != null || widget.serverError != null
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.validationError ?? widget.serverError ?? "",
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                )
              : Container(),
      ],
    );
  }
}
