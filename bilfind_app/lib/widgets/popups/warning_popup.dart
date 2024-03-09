import 'package:bilfind_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

class WarningPopup extends StatefulWidget {
  const WarningPopup({
    Key? key,
    required this.title,
    required this.content,
    this.cancelLabel = "Cancel",
    required this.approveLabel,
    required this.onApproved,
    required this.isAsync,
  }) : super(key: key);

  final String title;
  final String content;
  final String cancelLabel;
  final String approveLabel;

  final Function onApproved;
  final bool isAsync;

  @override
  State<WarningPopup> createState() => _WarningPopupState();
}

class _WarningPopupState extends State<WarningPopup> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              width: MediaQuery.of(context).size.width - 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.black2,
                border: Border.all(color: AppColors.mutedWhite, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.mutedWhite),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.content,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.subText),
                  ),
                  const SizedBox(height: 32),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Visibility(
                        visible: !isLoading,
                        maintainSize: true,
                        maintainState: true,
                        maintainAnimation: true,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: AppColors.mutedWhite,
                            ),
                            _getPopupButton(
                              onTap: () async {
                                if (widget.isAsync) {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  await widget.onApproved();

                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  widget.onApproved();
                                }
                              },
                              text: widget.approveLabel,
                              textColor: Colors.red,
                              context: context,
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: AppColors.mutedWhite,
                            ),
                            _getPopupButton(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                text: widget.cancelLabel,
                                context: context),
                          ],
                        ),
                      ),
                      isLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.mutedWhite,
                            )
                          : Container(),
                    ],
                  ),
                ],
              )),
        ),
      ],
    );
  }

  _getPopupButton({
    required VoidCallback onTap,
    required String text,
    required BuildContext context,
    Color textColor = AppColors.mutedWhite,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: textColor,
                ),
          ),
        ),
      ),
    );
  }
}
