import 'package:bot_chat_app/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import '../constants/constants.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({required this.message, Key? key}) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.sender == Sender.user;

    final text = Text(
      isUser ? 'Me' : 'Chat GPT',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
    );
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Card(
            color: isUser
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            margin: EdgeInsets.only(bottom: isUser ? 8.0 : 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  isUser
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: isUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isUser)
                              Image.asset('assets/images/logo.png', width: 30),
                            if (!isUser) const SizedBox(width: 10),
                            text,
                          ],
                        ),
                  const SizedBox(height: 10),
                  Text(
                    message.prompt,
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                  if (!isUser) const SizedBox(height: 20),
                  Text(DateFormat.jm().format(DateTime.now())),
                  if (!isUser)
                    TextButton.icon(
                      icon:
                          const Icon(Icons.copy, color: Colors.white, size: 15),
                      label: Text(
                        Constants.copy,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onPressed: () => _copyText(context),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _copyText(BuildContext context) {
    Toast.show(
      'Text Copied to Clipboard',
      textStyle: Theme.of(context).textTheme.bodyMedium,
    );
    Clipboard.setData(ClipboardData(text: message.prompt));
  }
}
