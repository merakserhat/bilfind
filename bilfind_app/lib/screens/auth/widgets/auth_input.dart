import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_theme.dart';

class AuthInput extends StatefulWidget {
  final String text;
  final String? validationError;
  final String? serverError;
  final TextEditingController textController;
  final bool isPass;

  const AuthInput({
    super.key,
    required this.textController,
    required this.text,
    this.validationError,
    this.serverError,
    this.isPass = false,
  });

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.text,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: AppColors.inputBorderColor,
                    fontWeight: FontWeight.w500),
              ),
              TextField(
                controller: widget.textController,
                obscureText: widget.isPass,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  fillColor: AppColors.silverGray,
                  filled: true,
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(width: 1, color: AppColors.inputBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          width: 1, color: AppColors.inputBorderColor)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          width: 1, color: AppColors.inputBorderColor)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          width: 1, color: AppColors.inputBorderColor)),
                ),
              ),
            ],
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
      ),
    );
  }
}
