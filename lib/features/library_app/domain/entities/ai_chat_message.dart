import 'package:equatable/equatable.dart';
import 'ai_book_source.dart';

class AIChatMessage extends Equatable {
  final String text;
  final bool isUser;
  final String sender;
  final bool isTyping;
  final bool isStreaming;
  final bool isError;
  final List<AIBookSource> sources;

  const AIChatMessage({
    required this.text,
    required this.isUser,
    required this.sender,
    this.isTyping = false,
    this.isStreaming = false,
    this.isError = false,
    this.sources = const [],
  });

  AIChatMessage copyWith({
    String? text,
    bool? isUser,
    String? sender,
    bool? isTyping,
    bool? isStreaming,
    bool? isError,
    List<AIBookSource>? sources,
  }) {
    return AIChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      sender: sender ?? this.sender,
      isTyping: isTyping ?? this.isTyping,
      isStreaming: isStreaming ?? this.isStreaming,
      isError: isError ?? this.isError,
      sources: sources ?? this.sources,
    );
  }

  @override
  List<Object?> get props => [
    text,
    isUser,
    sender,
    isTyping,
    isStreaming,
    isError,
    sources,
  ];
}
