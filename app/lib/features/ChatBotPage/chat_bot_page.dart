import 'dart:math';
import 'package:flutter/material.dart';

/// ===========================================================================
/// CHATBOT PAGE - AI PRONUNCIATION COACH INTERFACE
/// ===========================================================================
/// 
/// PURPOSE:
/// - Interactive chat interface for user-AI communication
/// - Provides conversational pronunciation coaching
/// - Features smooth animations and realistic chat experience
/// - Simulates AI responses with typing indicators
/// 
/// KEY FEATURES:
/// - Animated message transitions with slide effects
/// - Real-time typing indicators
/// - Pre-defined AI response system
/// - Modern chat UI with gradient app bar
/// - Responsive design for all screen sizes
/// 
/// ARCHITECTURE:
/// - Stateful widget with SingleTickerProviderStateMixin
/// - AnimatedList for smooth message management
/// - Custom typing indicator with animation
/// - Random response selection for variety
/// ===========================================================================

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage>
    with SingleTickerProviderStateMixin {
  // Text editing controller for message input
  final TextEditingController _controller = TextEditingController();
  
  // Key for animated list to manage message transitions
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  
  // List to store all chat messages with sender and text
  final List<Map<String, String>> _messages = [];

  /// Pre-defined responses for the AI pronunciation coach
  /// These simulate AI responses until full AI integration
  final List<String> _botResponses = [
    "I'm still learning to talk, please be patient 😅",
    "That sounds interesting!",
    "Can you tell me more?",
    "I'll be smarter soon 🤖",
    "Hmm, not sure I understand yet.",
    "Cool! Tell me more about that.",
  ];

  /// Tracks whether the bot is currently "typing"
  bool _botTyping = false;

  /// =========================================================================
  /// MESSAGE MANAGEMENT
  /// =========================================================================
  
  /// Handles sending user messages and triggering bot responses
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Create user message object
    final userMessage = {'sender': 'user', 'text': text};

    // Clear input and add message to chat
    _controller.clear();
    _insertMessage(userMessage);

    // Show typing indicator
    setState(() => _botTyping = true);

    // Simulate AI processing delay and response
    Future.delayed(const Duration(milliseconds: 1200), () {
      final randomResponse =
          _botResponses[Random().nextInt(_botResponses.length)];
      setState(() => _botTyping = false);
      _insertMessage({'sender': 'bot', 'text': randomResponse});
    });
  }

  /// Inserts a new message into the animated list with smooth transition
  void _insertMessage(Map<String, String> message) {
    _messages.add(message);
    _listKey.currentState?.insertItem(
      _messages.length - 1,
      duration: const Duration(milliseconds: 400),
    );
  }

  /// =========================================================================
  /// UI BUILDING METHODS
  /// =========================================================================
  
  /// Builds individual message bubbles with animations
  Widget _buildMessage(
    Map<String, String> message,
    Animation<double> animation,
  ) {
    final isUser = message['sender'] == 'user';
    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 0.0,
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: isUser ? Colors.blueAccent : Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: isUser
                  ? const Radius.circular(18)
                  : const Radius.circular(4),
              bottomRight: isUser
                  ? const Radius.circular(4)
                  : const Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: const Offset(1, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            message['text'] ?? '',
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black87,
              fontSize: 16,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds animated typing indicator for bot responses
  Widget _buildTypingIndicator() {
    return AnimatedOpacity(
      opacity: _botTyping ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 10, top: 6),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: const TypingIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Icon(Icons.record_voice_over, color: Colors.blueAccent),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Pronunciation Coach",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "Online",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),

      /// =====================================================================
      /// MAIN CHAT INTERFACE
      /// =====================================================================
      body: Column(
        children: [
          // Message list area
          Expanded(
            child: AnimatedList(
              key: _listKey,
              reverse: false,
              padding: const EdgeInsets.only(top: 8),
              initialItemCount: _messages.length,
              itemBuilder: (context, index, animation) =>
                  _buildMessage(_messages[index], animation),
            ),
          ),
          
          // Typing indicator (only visible when bot is typing)
          if (_botTyping) _buildTypingIndicator(),
          
          // Input area divider
          const Divider(height: 1),
          
          // Message input section
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  // Text input field
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  
                  // Send button
                  GestureDetector(
                    onTap: _sendMessage,
                    child: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      radius: 24,
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===========================================================================
/// TYPING INDICATOR COMPONENT
/// ===========================================================================
/// 
/// PURPOSE:
/// - Visual representation of AI "typing" state
/// - Animated dots that bounce to simulate typing activity
/// - Provides user feedback that AI is processing response
/// 
/// ANIMATION:
/// - Three dots with sinusoidal vertical movement
/// - Continuous looping animation
/// - Smooth bouncing effect
/// ===========================================================================

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  TypingIndicatorState createState() => TypingIndicatorState();
}

class TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Create animation controller with 1-second loop
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Calculate vertical offset using sine wave for bouncing effect
            final offset = sin((_controller.value * 2 * pi) + (i * 0.5));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.translate(
                offset: Offset(0, offset * 3),
                child: const CircleAvatar(
                  radius: 3,
                  backgroundColor: Colors.grey,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
