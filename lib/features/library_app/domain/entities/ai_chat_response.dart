import 'package:equatable/equatable.dart';
import 'ai_book_source.dart';

class AIChatResponse extends Equatable {
  final String answer;
  final String? sessionId;
  final List<AIBookSource> sources;

  const AIChatResponse({
    required this.answer,
    this.sessionId,
    this.sources = const [],
  });

  @override
  List<Object?> get props => [answer, sessionId, sources];
}
