import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/ai_book_source.dart';
import '../../bloc/message/ai_chat_bloc.dart';
import '../book/detail_page.dart';
import 'ai_book_card.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => AIChatPageState();
}

class AIChatPageState extends State<AIChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Public getter for session ID (used by MessagePage to clear history)
  String? get sessionId => getIt<AIChatBloc>().state.sessionId;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    _messageController.clear();

    context.read<AIChatBloc>().add(SendAIChatMessage(message));

    // Scroll to bottom after sending
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
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
    return BlocConsumer<AIChatBloc, AIChatState>(
      listener: (context, state) {
        // Auto scroll when new messages arrive
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      },
      builder: (context, state) {
        final isLoading = state is AIChatLoading;
        final isStreaming = state is AIChatStreaming;
        final messages = state.messages;

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 72, 16, 16),
                controller: _scrollController,
                reverse: true,
                physics: const ClampingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  // With reverse: true, display messages from newest to oldest
                  final message = messages[messages.length - 1 - index];
                  if (message.isTyping) {
                    return _TypingBubble(isUser: false, sender: message.sender);
                  }
                  return _MessageBubble(
                    message: message.text,
                    isUser: message.isUser,
                    sender: message.sender,
                    isError: message.isError,
                    isStreaming: message.isStreaming,
                    sources: message.sources,
                  );
                },
              ),
            ),
            _buildInputField(isLoading, isStreaming),
          ],
        );
      },
    );
  }

  Widget _buildInputField(bool isLoading, bool isStreaming) {
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
                  enabled: !isLoading && !isStreaming,
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
              onTap: () {
                if (isStreaming) {
                  // Stop streaming
                  context.read<AIChatBloc>().add(const StopStreaming());
                } else if (!isLoading) {
                  // Send message
                  _sendMessage();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isLoading || isStreaming
                      ? Colors.red.shade400
                      : AppColors.primaryButton,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isStreaming ? Icons.pause : Icons.send,
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
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String sender;
  final bool isError;
  final bool isStreaming;
  final List<AIBookSource> sources;

  const _MessageBubble({
    required this.message,
    required this.isUser,
    required this.sender,
    this.isError = false,
    this.isStreaming = false,
    this.sources = const [],
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
              child: Row(
                children: [
                  Text(
                    sender,
                    style: TextStyle(
                      color: AppColors.subText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isStreaming) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: AppColors.primaryButton,
                      ),
                    ),
                  ],
                ],
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
                        : isError
                        ? Colors.red.shade50
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
                  child: SelectableText(
                    message,
                    style: TextStyle(
                      color: isError ? Colors.red.shade700 : AppColors.bodyText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Display book sources if available
          if (!isUser && sources.isNotEmpty && !isStreaming) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'Sách liên quan:',
                style: TextStyle(
                  color: AppColors.subText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sources.length,
              itemBuilder: (context, index) {
                final source = sources[index];
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 8,
                    right: index == sources.length - 1 ? 0 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            bookId: int.parse(source.identifier),
                            initialCoverUrl: null,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 160,
                      child: AIBookCard(source: source),
                    ),
                  ),
                );
              },
            ),
          ],
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
