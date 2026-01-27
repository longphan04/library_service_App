import '../../domain/entities/ai_chat_response.dart';
import 'ai_book_source_model.dart';

class AIChatResponseModel {
  final String answer;
  final String? sessionId;
  final List<AIBookSourceModel> sources;

  AIChatResponseModel({
    required this.answer,
    this.sessionId,
    this.sources = const [],
  });

  factory AIChatResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final sourcesData = data['sources'] as List<dynamic>? ?? [];

    return AIChatResponseModel(
      answer: data['answer'] as String? ?? '',
      sessionId: data['session_id'] as String?,
      sources: sourcesData
          .map((s) => AIBookSourceModel.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'session_id': sessionId,
      'sources': sources.map((s) => s.toJson()).toList(),
    };
  }

  AIChatResponse toEntity() {
    return AIChatResponse(
      answer: answer,
      sessionId: sessionId,
      sources: sources.map((s) => s.toEntity()).toList(),
    );
  }
}
