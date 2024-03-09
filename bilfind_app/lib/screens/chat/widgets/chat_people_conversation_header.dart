import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class ChatPeopleConversationsHeader extends StatelessWidget {
  const ChatPeopleConversationsHeader(
      {Key? key,
      required this.textEditingController,
      required this.callbackFunction})
      : super(key: key);
  final TextEditingController textEditingController;
  final Function(String) callbackFunction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            "Inbox",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColors.mutedWhite),
          ),
          const SizedBox(height: 4),
          CustomSearchBar(
              callbackFunction: callbackFunction,
              controller: textEditingController,
              hint: "Search people",
              onSearched: (_) {}),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
