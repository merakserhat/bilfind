import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/conversation_model.dart';
import 'package:bilfind_app/screens/chat/widgets/chat_people_conversation_header.dart';
import 'package:bilfind_app/screens/chat/widgets/chat_people_person.dart';
import 'package:bilfind_app/widgets/shimmered_chat_item.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatPeoplePart extends StatefulWidget {
  const ChatPeoplePart({
    Key? key,
    required this.conversations,
    required this.dataLoading,
    this.selectedConversation,
    required this.onSelectConversation,
  }) : super(key: key);

  final List<ConversationModel> conversations;
  final bool dataLoading;
  final ConversationModel? selectedConversation;
  final Function(ConversationModel) onSelectConversation;

  @override
  State<ChatPeoplePart> createState() => _ChatPeoplePartState();
}

class _ChatPeoplePartState extends State<ChatPeoplePart> {
  final TextEditingController textEditingController = TextEditingController();
  List<ConversationModel> conversations = [];

  @override
  void initState() {
    super.initState();
    conversations = widget.conversations;
  }

  @override
  Widget build(BuildContext context) {
    conversations = widget.conversations;

    return Column(
      children: [
        ChatPeopleConversationsHeader(
          textEditingController: textEditingController,
          callbackFunction: onNameSearched,
        ),
        Expanded(
          child: widget.dataLoading
              ? SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                        6,
                        (index) => Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 52, 52, 52),
                            highlightColor:
                                const Color.fromARGB(255, 81, 80, 80),
                            enabled: true,
                            child: const ShimmeredChatItem())),
                  ),
                )
              : ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    return ChatPeoplePerson(
                      conversationModel: conversations[index],
                      onSelectConversation: widget.onSelectConversation,
                    );
                  },
                ),
        )
      ],
    );
  }

  void onNameSearched(String value) {}
}
