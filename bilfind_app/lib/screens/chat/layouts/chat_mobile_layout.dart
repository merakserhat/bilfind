import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/conversation_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/screens/chat/parts/chat_conversation_part.dart';
import 'package:bilfind_app/screens/chat/parts/chat_people_part.dart';
import 'package:bilfind_app/widgets/app_bar/authenticated_app_bar.dart';
import 'package:flutter/material.dart';

class ChatMobileLayout extends StatelessWidget {
  const ChatMobileLayout({
    Key? key,
    required this.conversations,
    required this.dataLoading,
    this.selectedConversation,
    required this.onSelectConversation,
    required this.onBack,
  }) : super(key: key);

  final List<ConversationModel> conversations;
  final bool dataLoading;
  final ConversationModel? selectedConversation;
  final Function(ConversationModel) onSelectConversation;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthenticatedAppBar(
          userRetrieved: Program().userModel != null,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: selectedConversation == null
                ? ChatPeoplePart(
                    conversations: conversations,
                    dataLoading: dataLoading,
                    selectedConversation: selectedConversation,
                    onSelectConversation: onSelectConversation,
                  )
                : ChatConversationPart(
                    conversationModel: selectedConversation!,
                    onBack: onBack,
                  ),
          ),
        ),
      ],
    );
  }
}
