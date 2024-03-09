import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/conversation_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/screens/chat/parts/chat_conversation_part.dart';
import 'package:bilfind_app/screens/chat/parts/chat_people_part.dart';
import 'package:bilfind_app/widgets/app_bar/authenticated_app_bar.dart';
import 'package:flutter/material.dart';

class ChatTabletLayout extends StatelessWidget {
  const ChatTabletLayout({
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthenticatedAppBar(
          userRetrieved: Program().userModel != null,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: SizedBox(
                height: 800,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ChatPeoplePart(
                          conversations: conversations,
                          dataLoading: dataLoading,
                          selectedConversation: selectedConversation,
                          onSelectConversation: onSelectConversation,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      flex: 6,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: selectedConversation == null
                            ? Column(
                                children: [
                                  const SizedBox(height: 150),
                                  Container(
                                    width: double.infinity,
                                    height: 400,
                                    child: Image.network(
                                        "https://cdn-icons-png.flaticon.com/512/9171/9171503.png"),
                                  ),
                                  const SizedBox(height: 40),
                                  Text(
                                    "No Selected Chat",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(color: AppColors.mutedWhite),
                                  ),
                                ],
                              )
                            : ChatConversationPart(
                                conversationModel: selectedConversation!),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
