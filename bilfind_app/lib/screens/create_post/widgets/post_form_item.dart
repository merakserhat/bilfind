import 'package:bilfind_app/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostFormItem extends StatelessWidget {
  const PostFormItem({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChange,
    this.error,
    this.isNumber = false,
  });

  final bool isNumber;
  final String hintText;
  final String? error;
  final TextEditingController controller;
  final Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: double.infinity,
          height: hintText == "Description" ? 150 : null,
          child: TextField(
            minLines: hintText == "Description" ? 7 : 1,
            maxLines: null,
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : null,
            inputFormatters: isNumber
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ]
                : null,
            cursorColor: AppColors.mutedWhite,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.mutedWhite, fontWeight: FontWeight.w500),
            onChanged: onChange,
            decoration: InputDecoration(
              suffixText: hintText == "Price" ? "₺" : null,
              suffixStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: AppColors.white),
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColors.black6, fontWeight: FontWeight.w500),
              fillColor: AppColors.primary,
              filled: true,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      const BorderSide(width: 1, color: AppColors.black6)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      const BorderSide(width: 1, color: AppColors.black6)),
            ),
          ),
        ),
        error != null
            ? Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    error ?? "",
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                ),
              )
            : Container(),
        const SizedBox(height: 8),
      ],
    );
  }
}
