enum Sender { user, bot }

class ChatMessage {
  final String prompt;
  final Sender sender;
  final bool isError;

  const ChatMessage(
      {required this.prompt, required this.sender, this.isError = false});
}
