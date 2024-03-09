import 'package:bilfind_app/constants/app_constants.dart';
import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/conversation_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:flutter/material.dart';

class ChatPeoplePerson extends StatefulWidget {
  const ChatPeoplePerson(
      {Key? key,
      required this.conversationModel,
      required this.onSelectConversation})
      : super(key: key);
  final ConversationModel conversationModel;
  final Function(ConversationModel) onSelectConversation;

  @override
  State<ChatPeoplePerson> createState() => _ChatPeoplePersonState();
}

class _ChatPeoplePersonState extends State<ChatPeoplePerson> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onSelectConversation(widget.conversationModel);
      },
      onHover: (value) {
        setState(() {
          hover = value;
        });
      },
      splashFactory: NoSplash.splashFactory,
      child: Container(
        height: 72,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
            color: hover ? Colors.white10 : Colors.transparent,
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  widget.conversationModel.getChatImageUrl(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  widget.conversationModel.getChatUserName(),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: AppColors.mutedWhite),
                ),
                Text(
                  "On post - " + widget.conversationModel.post.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: AppColors.mutedWhite),
                ),
                Text(
                  widget.conversationModel.messages.isNotEmpty
                      ? widget.conversationModel.messages.last.text
                      : "",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: AppColors.subText),
                ),
              ],
            )),
            const SizedBox(width: 16),
            Text(
              "1h",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: AppColors.subText),
            ),
          ],
        ),
      ),
    );
  }
}
