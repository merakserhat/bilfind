import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatefulWidget {
  final String content;
  final bool isContinuation;
  final bool isOwnMessage;
  final DateTime date;

  const ChatBubble({
    Key? key,
    this.content = "",
    this.isContinuation = false,
    this.isOwnMessage = true,
    required this.date,
  }) : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool displayingData = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          displayingData = !displayingData;
        });
      },
      child: Stack(
        children: [
          Align(
            alignment: widget.isOwnMessage
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: _getContent(content: widget.content, context: context),
          ),
        ],
      ),
    );
  }

  Widget _getContent({required String content, required BuildContext context}) {
    double maxWidth = Responsive.isMobile(context)
        ? MediaQuery.of(context).size.width * 0.6
        : MediaQuery.of(context).size.width * 0.2;

    return Container(
      width: maxWidth,
      margin: EdgeInsets.only(
          left: 16, right: 16, bottom: 0, top: widget.isContinuation ? 8 : 16),
      child: AnimatedSize(
        duration: Duration(milliseconds: 200),
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: widget.isOwnMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: maxWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: widget.isOwnMessage
                    ? AppColors.bilkentBlue
                    : AppColors.black4,
              ),
              child: Text(
                content,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(height: 1.2, color: Colors.white),
                softWrap: true,
                textAlign: TextAlign.left,
              ),
            ),
            displayingData
                ? Text(
                    DateFormat('yyyy-MM-dd – kk:mm').format(widget.date),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.mutedWhite),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
