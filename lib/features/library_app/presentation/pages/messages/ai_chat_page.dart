import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    final userText = _messageController.text.trim();

    setState(() {
      _messages.add(ChatMessage(text: userText, isUser: true, sender: 'Bạn'));
      _messageController.clear();
      // show AI typing indicator
      _removeExistingTyping();
      _messages.add(
        ChatMessage(text: '', isUser: false, sender: 'AI', isTyping: true),
      );
    });

    // Smoothly scroll to the newest message (anchored at bottom)
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // Simulate AI response after short delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      final reply = _generateAIResponse(userText);
      setState(() {
        _removeExistingTyping();
        _messages.add(ChatMessage(text: reply, isUser: false, sender: 'AI'));
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 72, 16, 16),
            controller: _scrollController,
            reverse: true,
            physics: const ClampingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              // With reverse: true, display messages from newest to oldest
              final message = _messages[_messages.length - 1 - index];
              if (message.isTyping) {
                return _TypingBubble(isUser: false, sender: message.sender);
              }
              return _MessageBubble(
                message: message.text,
                isUser: message.isUser,
                sender: message.sender,
              );
            },
          ),
        ),
        _buildInputField(),
      ],
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: TextField(
                  controller: _messageController,
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Hỏi Chat AI',
                    hintStyle: TextStyle(
                      color: AppColors.subText,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: TextStyle(color: AppColors.bodyText, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryButton,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.send,
                  color: AppColors.buttonPrimaryText,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeExistingTyping() {
    final typingIndex = _messages.lastIndexWhere((m) => m.isTyping);
    if (typingIndex != -1) {
      _messages.removeAt(typingIndex);
    }
  }

  String _generateAIResponse(String userText) {
    // Simple demo response. Replace with real AI call later.
    return 'AI: Đã nhận câu hỏi của bạn: "$userText"';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String sender;
  final bool isTyping;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.sender,
    this.isTyping = false,
  });
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String sender;

  const _MessageBubble({
    required this.message,
    required this.isUser,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(
                sender,
                style: TextStyle(
                  color: AppColors.subText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isUser)
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 8),
                  child: Text(
                    sender,
                    style: TextStyle(
                      color: AppColors.subText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.secondaryButton
                        : AppColors.sectionBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: AppColors.bodyText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  final bool isUser;
  final String sender;

  const _TypingBubble({required this.isUser, required this.sender});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(
                sender,
                style: TextStyle(
                  color: AppColors.subText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isUser)
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 8),
                  child: Text(
                    sender,
                    style: TextStyle(
                      color: AppColors.subText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.sectionBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const TypingIndicator(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  final double dotSize;
  final Color? dotColor;

  const TypingIndicator({super.key, this.dotSize = 6, this.dotColor});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Interval interval) {
    final color = widget.dotColor ?? AppColors.bodyText;
    final animation = CurvedAnimation(parent: _controller, curve: interval);
    return ScaleTransition(
      scale: Tween<double>(begin: 0.7, end: 1.0).animate(animation),
      child: Opacity(
        opacity: Tween<double>(begin: 0.6, end: 1.0).evaluate(animation),
        child: Container(
          width: widget.dotSize,
          height: widget.dotSize,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(const Interval(0.0, 0.33, curve: Curves.easeInOut)),
        const SizedBox(width: 4),
        _buildDot(const Interval(0.33, 0.66, curve: Curves.easeInOut)),
        const SizedBox(width: 4),
        _buildDot(const Interval(0.66, 1.0, curve: Curves.easeInOut)),
      ],
    );
  }
}
