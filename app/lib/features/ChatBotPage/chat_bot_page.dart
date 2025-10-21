import 'dart:math';
import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget{
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage>{
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  final List<String> _botResponses = [
    "I'm still learning to talk, please be patient 😅",
    "That sounds interesting!",
    "Can you tell me more?",
    "I'll be smarter soon 🤖",
    "Hmm, not sure I understand yet.",
    "Cool! Tell me more about that.",
  ];

  void _sendMessage(){
    final text = _controller.text.trim();
    if(text.isEmpty) return;

    setState((){
      _messages.add({'sender': 'user', 'text': text});
    });

    _controller.clear();

    Future.delayed(const Duration(seconds: 1), (){
      final randomResponse = _botResponses[Random().nextInt(_botResponses.length)];
      setState((){
        _messages.add({'sender': 'bot', 'text': randomResponse});
      });
    });
  }
  Widget _buildMessage(Map<String, String> message){
    final isUser = message['sender'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message['text'] ?? '',
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
      title: const Text("Chatbot (placeholder)"),
      backgroundColor: Colors.blueAccent,
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) => _buildMessage(_messages[index]),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(
                    hintText: "Type your message...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blueAccent),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    ),
  );
  }
}


