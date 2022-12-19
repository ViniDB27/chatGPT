import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_api/flutter_chatgpt_api.dart';

import 'config/clearance_token.dart';
import 'config/session_token.dart';
import 'config/user_agent.dart';
import 'widgets/input_message_widget.dart';
import 'widgets/text_box_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Chat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController = TextEditingController();
  final scrollController = ScrollController();
  final List<ChatMessage> messages = [];
  late ChatGPTApi api;

  String? parentMessageId;
  String? conversationId;
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    api = ChatGPTApi(
      sessionToken: SESSION_TOKEN,
      clearanceToken: CLEARANCE_TOKEN,
      userAgent: USER_AGENT,
    );
    isLoading = false;
  }

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  sendNewMessage() async {
    setState(
      () {
        messages.add(
          ChatMessage(
            text: textController.text,
            chatMessageType: ChatMessageType.user,
          ),
        );
        isLoading = true;
      },
    );

    var input = textController.text;
    textController.clear();

    await Future.delayed(const Duration(milliseconds: 50))
        .then((_) => scrollDown());

    var newMessage = await api.sendMessage(
      input,
      conversationId: conversationId,
      parentMessageId: parentMessageId,
    );

    setState(() {
      conversationId = newMessage.conversationId;
      parentMessageId = newMessage.messageId;
      isLoading = false;
      messages.add(
        ChatMessage(
          text: newMessage.message,
          chatMessageType: ChatMessageType.bot,
        ),
      );
    });
    textController.clear();
    Future.delayed(const Duration(milliseconds: 50)).then((_) => scrollDown());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (ctx, index) => TextBox(
                      message: messages[index],
                    ),
                  ),
                ),
              ),
              InputMessage(
                controller: textController,
                onPressed: sendNewMessage,
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
