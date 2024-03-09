import 'package:bilfind_app/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceFilterField extends StatelessWidget {
  const PriceFilterField(
      {Key? key, required this.hint, required this.controller})
      : super(key: key);

  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(fontSize: 16, color: AppColors.mutedWhite),
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        hintText: hint,
        fillColor: AppColors.black4,
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: AppColors.subText, fontSize: 16),
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(width: 1, color: Colors.transparent)),
        filled: true,
        isDense: true,
      ),
    );
  }
}
