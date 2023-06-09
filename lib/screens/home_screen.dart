import 'package:bot_chat_app/api/api_handler.dart';
import 'package:bot_chat_app/widgets/chat_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../constants/constants.dart';
import '../models/chat_message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double width;

  final _messages = <ChatMessage>[];
  final _prompts = <String>[];
  final _controller = TextEditingController();

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    width = MediaQuery.of(context).size.width;
    ToastContext().init(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: width * 0.95,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) =>
                          ChatMessageWidget(message: _messages[index]),
                    ),
                  ),
                  const SizedBox(height: 90),
                ],
              ),
              Positioned(
                bottom: 10,
                child: buildSendTextRow(),
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSendTextRow() {
    return Container(
      width: width * 0.95,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(16, 18, 19, 1),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: Constants.type,
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              textInputAction: TextInputAction.done,
              onEditingComplete: _onPressed,
            ),
          ),
          IconButton(
            onPressed: _onPressed,
            icon: const Icon(Icons.send, size: 35, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _onPressed() async {
    FocusScope.of(context).unfocus();

    final prompt = _controller.text.trim();
    _controller.text = '';
    _prompts.add(prompt);

    _update(true, ChatMessage(prompt: prompt, sender: Sender.user));

    final response = await ApiHandler.getResponse(_prompts);

    final ChatMessage message = ChatMessage(
      prompt: response['message'],
      sender: Sender.bot,
      isError: !response['success'],
    );

    _prompts.add(response['message']);
    _update(false, message);
  }

  void _update(bool isLoading, ChatMessage message) {
    setState(() {
      _isLoading = isLoading;
      _messages.insert(0, message);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
