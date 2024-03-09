import 'package:bilfind_app/models/comment_model.dart';
import 'package:bilfind_app/models/conversation_model.dart';
import 'package:bilfind_app/models/message_model.dart';
import 'package:bilfind_app/models/post_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/response/get_post_detail_response.dart';
import 'package:bilfind_app/models/response/message_response.dart';
import 'package:bilfind_app/screens/auth/auth_screen.dart';
import 'package:bilfind_app/screens/chat/layouts/chat_desktop_layout.dart';
import 'package:bilfind_app/screens/chat/layouts/chat_mobile_layout.dart';
import 'package:bilfind_app/screens/chat/layouts/chat_tablet_layout.dart';
import 'package:bilfind_app/services/chat_service.dart';
import 'package:bilfind_app/services/socket_service.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, this.conversationModel}) : super(key: key);

  final ConversationModel? conversationModel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> implements SocketListenable {
  List<ConversationModel> conversations = [];
  bool dataLoading = true;
  ConversationModel? selectedConversation;
  bool getDataRan = false;

  getData() async {
    if (widget.conversationModel != null) {
      selectedConversation = widget.conversationModel;
    }

    getDataRan = true;

    conversations = await ChatService.getConversations();
    dataLoading = false;

    if (widget.conversationModel != null) {
      for (ConversationModel conv in conversations) {
        if (conv.post.id == widget.conversationModel!.post.id &&
            conv.senderId == widget.conversationModel!.senderId) {
          setState(() {
            selectedConversation = conv;
          });

          break;
        }
      }
    }

    for (var element in conversations) {
      SocketService().joinConversation(element);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    SocketService().register(this);

    Program().retrieveUser().then((retrieved) {
      if (retrieved) {
        setState(() {});
        getData();
      } else {
        context.go(RouteGenerator().authRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!getDataRan) {
        getData();
      }
    });

    conversations.sort((a, b) {
      DateTime aDate =
          a.messages.isNotEmpty ? a.messages.last.createdAt : a.createdAt;
      DateTime bDate =
          b.messages.isNotEmpty ? b.messages.last.createdAt : b.createdAt;
      return bDate.compareTo(aDate);
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: ((Theme.of(context).brightness == Brightness.dark)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            .copyWith(
          statusBarColor: Theme.of(context).colorScheme.background,
        ),
        child: Program().userModel == null
            ? Container()
            : Responsive(
                mobile: ChatMobileLayout(
                  conversations: conversations,
                  dataLoading: dataLoading,
                  selectedConversation: selectedConversation,
                  onSelectConversation: onSelectConversation,
                  onBack: () {
                    setState(() {
                      selectedConversation = null;
                    });
                  },
                ),
                tablet: ChatTabletLayout(
                  conversations: conversations,
                  dataLoading: dataLoading,
                  selectedConversation: selectedConversation,
                  onSelectConversation: onSelectConversation,
                ),
                desktop: ChatDesktopLayout(
                  conversations: conversations,
                  dataLoading: dataLoading,
                  selectedConversation: selectedConversation,
                  onSelectConversation: onSelectConversation,
                ),
              ),
      ),
    );
  }

  onSelectConversation(ConversationModel conversationModel) {
    setState(() {
      selectedConversation = conversationModel;
    });
  }

  @override
  void updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    SocketService().dispose();
  }

  @override
  void onGetMessage(MessageResponse messageResponse) {
    int foundIndex = -1;
    for (int i = 0; i < conversations.length; i++) {
      if (conversations[i].id == messageResponse.conversationId) {
        foundIndex = i;
        break;
      }
    }

    if (foundIndex == -1) {
      return;
    }
    ConversationModel conversationModel = conversations[foundIndex];
    conversationModel.messages.add(
      MessageModel(
        conversationId: messageResponse.conversationId,
        senderId: messageResponse.userId,
        createdAt: DateTime.now(),
        text: messageResponse.content,
        messageType: "TEXT",
      ),
    );
    setState(() {});
  }

  @override
  void updateWithNewConversation(ConversationModel conversationModel) async {
    await getData();
    for (ConversationModel con in conversations) {
      if (con.id == conversationModel.id) {
        setState(() {
          selectedConversation = con;
        });
      }
    }
  }
}
