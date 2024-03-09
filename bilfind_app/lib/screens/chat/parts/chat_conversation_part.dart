import 'dart:math';

import 'package:bilfind_app/constants/app_constants.dart';
import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/conversation_model.dart';
import 'package:bilfind_app/models/message_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/screens/chat/widgets/chat_app_bar.dart';
import 'package:bilfind_app/screens/chat/widgets/chat_bubble.dart';
import 'package:bilfind_app/services/chat_service.dart';
import 'package:bilfind_app/services/socket_service.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/material.dart';

class ChatConversationPart extends StatefulWidget {
  const ChatConversationPart(
      {Key? key, required this.conversationModel, this.onBack})
      : super(key: key);

  final ConversationModel conversationModel;
  final VoidCallback? onBack;

  @override
  ChatConversationPartState createState() => ChatConversationPartState();
}

class ChatConversationPartState extends State<ChatConversationPart> {
  TextEditingController textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChatAppBar(
          fullName: widget.conversationModel.getChatUserName(),
          imageUrl: widget.conversationModel.getChatImageUrl(),
          onBack: widget.onBack,
        ),
        Expanded(child: _getMessages()),
        const Divider(),
        _getTextBar(),
      ],
    );
  }

  Widget _getTextBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: textEditingController,
              cursorColor: AppColors.mutedWhite,
              keyboardType: TextInputType.multiline,
              focusNode: _focusNode,
              onSubmitted: (value) {
                onMessageSent();
              },
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: AppColors.mutedWhite),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                hintText: "Write message",
                isDense: true,
                filled: true,
                fillColor: AppColors.black4,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppColors.subText),
              ),
            ),
          ),
          const SizedBox.square(dimension: 5),
          _getSendButton(),
        ],
      ),
    );
  }

  Widget _getSendButton() {
    return InkWell(
      onTap: onMessageSent,
      child: Container(
          width: Responsive.isMobile(context) ? 38 : 80,
          height: 38,
          decoration: const BoxDecoration(
            color: AppColors.bilkentBlue,
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          margin: EdgeInsets.zero,
          child: const Icon(
            Icons.send,
            size: 16,
            color: Colors.white,
          )),
    );
  }

  onMessageSent() async {
    if (textEditingController.value.text.isNotEmpty) {
      // context
      //     .read<ChatBloc>()
      //     .add(ChatSendMessage(text: textEditingController.value.text));
      setState(() {
        widget.conversationModel.messages.add(
          MessageModel(
              senderId: Program().userModel!.id,
              text: textEditingController.text,
              createdAt: DateTime.now(),
              conversationId: widget.conversationModel.id,
              messageType: "TEXT"),
        );
      });
      FocusScope.of(context).requestFocus(_focusNode);

      //if conversation room is not created yet
      if (widget.conversationModel.id == AppConstants.mockConvId) {
        print("it is in mock");
        ChatService.createConversation(widget.conversationModel.post.id)
            .then((conv) {
          print(conv);
          if (conv != null) {
            SocketService().sendMessage(conv, textEditingController.text);
            if (SocketService().socketListenable != null) {
              SocketService().socketListenable!.updateWithNewConversation(conv);
            }
            setState(() {
              textEditingController.text = "";
            });
          }
          print("Something went wrong while creating conversation");
        });
      } else {
        SocketService()
            .sendMessage(widget.conversationModel, textEditingController.text);
        SocketService().updateListeners();
        setState(() {
          textEditingController.text = "";
        });
      }
    }
  }

  final ScrollController _scrollController = ScrollController();

  Widget _getMessages() {
    //SingleChildScrollView is not a good idea to use in a chat app but
    //There won't be a huge message history so it is not a big problem
    return SingleChildScrollView(
      controller: _scrollController,
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          });
          return Column(
            children: [
              ...List.generate(
                widget.conversationModel.messages.length,
                (index) => ChatBubble(
                  isContinuation: index == 0
                      ? false
                      : widget.conversationModel.messages[index].senderId ==
                          widget.conversationModel.messages[index - 1].senderId,
                  isOwnMessage:
                      widget.conversationModel.messages[index].senderId ==
                          Program().userModel!.id,
                  content: widget.conversationModel.messages[index].text,
                  date: widget.conversationModel.messages[index].createdAt,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
