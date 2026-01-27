part of 'ai_chat_bloc.dart';

abstract class AIChatEvent extends Equatable {
  const AIChatEvent();

  @override
  List<Object?> get props => [];
}

class SendAIChatMessage extends AIChatEvent {
  final String message;

  const SendAIChatMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class ClearAIChatHistory extends AIChatEvent {
  const ClearAIChatHistory();
}

class UpdateStreamingText extends AIChatEvent {
  final String text;

  const UpdateStreamingText(this.text);

  @override
  List<Object?> get props => [text];
}

class CompleteStreaming extends AIChatEvent {
  const CompleteStreaming();
}

class StopStreaming extends AIChatEvent {
  const StopStreaming();
}

class ResetAIChat extends AIChatEvent {
  const ResetAIChat();
}
