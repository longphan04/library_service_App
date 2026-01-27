part of 'ai_chat_bloc.dart';

abstract class AIChatState extends Equatable {
  final List<AIChatMessage> messages;
  final String? sessionId;

  const AIChatState({this.messages = const [], this.sessionId});

  @override
  List<Object?> get props => [messages, sessionId];
}

class AIChatInitial extends AIChatState {
  const AIChatInitial() : super();
}

class AIChatLoading extends AIChatState {
  const AIChatLoading({required super.messages, super.sessionId});
}

class AIChatStreaming extends AIChatState {
  final String currentStreamingText;
  final List<AIBookSource> pendingSources;

  const AIChatStreaming({
    required super.messages,
    super.sessionId,
    required this.currentStreamingText,
    required this.pendingSources,
  });

  @override
  List<Object?> get props => [
    messages,
    sessionId,
    currentStreamingText,
    pendingSources,
  ];
}

class AIChatLoaded extends AIChatState {
  const AIChatLoaded({required super.messages, super.sessionId});
}

class AIChatError extends AIChatState {
  final String error;

  const AIChatError({
    required super.messages,
    super.sessionId,
    required this.error,
  });

  @override
  List<Object?> get props => [messages, sessionId, error];
}
