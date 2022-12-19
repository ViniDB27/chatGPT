import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_api/flutter_chatgpt_api.dart';

class TextBox extends StatelessWidget {
  const TextBox({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width - 100,
      decoration: BoxDecoration(
        color: message.chatMessageType == ChatMessageType.user
            ? Colors.transparent
            : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: message.chatMessageType == ChatMessageType.user
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YWJzdHJhY3R8ZW58MHx8MHx8&w=1000&q=80"),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: Text(
              message.text,
              style: TextStyle(
                color: message.chatMessageType == ChatMessageType.user
                    ? Colors.black
                    : Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
