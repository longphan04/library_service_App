import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/error_handler.dart';
import '../../../domain/entities/ai_book_source.dart';
import '../../../domain/entities/ai_chat_message.dart';
import '../../../domain/usecases/message_usecase.dart';

part 'ai_chat_event.dart';
part 'ai_chat_state.dart';

class AIChatBloc extends Bloc<AIChatEvent, AIChatState> {
  final SendAIChatMessageUseCase sendAIChatMessageUseCase;
  final ClearAIChatHistoryUseCase clearAIChatHistoryUseCase;

  Timer? _typingTimer;
  int _currentCharIndex = 0;
  String _fullResponse = '';
  List<AIBookSource> _pendingSources = [];

  AIChatBloc({
    required this.sendAIChatMessageUseCase,
    required this.clearAIChatHistoryUseCase,
  }) : super(const AIChatInitial()) {
    on<SendAIChatMessage>(_onSendMessage);
    on<ClearAIChatHistory>(_onClearHistory);
    on<UpdateStreamingText>(_onUpdateStreamingText);
    on<CompleteStreaming>(_onCompleteStreaming);
    on<StopStreaming>(_onStopStreaming);
    on<ResetAIChat>(_onResetChat);
  }

  @override
  Future<void> close() {
    _typingTimer?.cancel();
    return super.close();
  }

  Future<void> _onSendMessage(
    SendAIChatMessage event,
    Emitter<AIChatState> emit,
  ) async {
    final userMessage = AIChatMessage(
      text: event.message,
      isUser: true,
      sender: 'Bạn',
    );

    final typingMessage = const AIChatMessage(
      text: '',
      isUser: false,
      sender: 'AI',
      isTyping: true,
    );

    final updatedMessages = [...state.messages, userMessage, typingMessage];

    emit(AIChatLoading(messages: updatedMessages, sessionId: state.sessionId));

    try {
      final response = await sendAIChatMessageUseCase(
        message: event.message,
        sessionId: state.sessionId,
      );

      // Remove typing indicator
      final messagesWithoutTyping = updatedMessages
          .where((m) => !m.isTyping)
          .toList();

      // Store response data for streaming
      _fullResponse = response.answer;
      _pendingSources = response.sources;
      _currentCharIndex = 0;

      // Add empty streaming message
      final streamingMessage = const AIChatMessage(
        text: '',
        isUser: false,
        sender: 'AI',
        isStreaming: true,
      );

      emit(
        AIChatStreaming(
          messages: [...messagesWithoutTyping, streamingMessage],
          sessionId: response.sessionId ?? state.sessionId,
          currentStreamingText: '',
          pendingSources: _pendingSources,
        ),
      );

      // Start streaming effect
      _startStreaming();
    } on DioException catch (e) {
      final errorMessage = ErrorHandler.getErrorMessage(e);
      _showError(emit, errorMessage);
    } catch (e) {
      _showError(emit, 'Có lỗi xảy ra: $e');
    }
  }

  void _startStreaming() {
    _typingTimer?.cancel();

    const charDelay = Duration(milliseconds: 5);
    _typingTimer = Timer.periodic(charDelay, (timer) {
      if (_currentCharIndex < _fullResponse.length) {
        _currentCharIndex++;
        add(UpdateStreamingText(_fullResponse.substring(0, _currentCharIndex)));
      } else {
        timer.cancel();
        add(const CompleteStreaming());
      }
    });
  }

  void _onUpdateStreamingText(
    UpdateStreamingText event,
    Emitter<AIChatState> emit,
  ) {
    if (state is AIChatStreaming) {
      final currentState = state as AIChatStreaming;
      final messages = currentState.messages.toList();

      if (messages.isNotEmpty) {
        messages[messages.length - 1] = AIChatMessage(
          text: event.text,
          isUser: false,
          sender: 'AI',
          isStreaming: true,
        );
      }

      emit(
        AIChatStreaming(
          messages: messages,
          sessionId: currentState.sessionId,
          currentStreamingText: event.text,
          pendingSources: currentState.pendingSources,
        ),
      );
    }
  }

  void _onCompleteStreaming(
    CompleteStreaming event,
    Emitter<AIChatState> emit,
  ) {
    if (state is AIChatStreaming) {
      final currentState = state as AIChatStreaming;
      final messages = currentState.messages.toList();

      if (messages.isNotEmpty) {
        messages[messages.length - 1] = AIChatMessage(
          text: _fullResponse,
          isUser: false,
          sender: 'AI',
          isStreaming: false,
          sources: _pendingSources,
        );
      }

      emit(AIChatLoaded(messages: messages, sessionId: currentState.sessionId));
    }
  }

  void _showError(Emitter<AIChatState> emit, String errorMessage) {
    final messagesWithoutTyping = state.messages
        .where((m) => !m.isTyping)
        .toList();

    final errorChatMessage = AIChatMessage(
      text: errorMessage,
      isUser: false,
      sender: 'AI',
      isError: true,
    );

    emit(
      AIChatError(
        messages: [...messagesWithoutTyping, errorChatMessage],
        sessionId: state.sessionId,
        error: errorMessage,
      ),
    );
  }

  Future<void> _onClearHistory(
    ClearAIChatHistory event,
    Emitter<AIChatState> emit,
  ) async {
    final sessionId = state.sessionId;
    if (sessionId != null && sessionId.isNotEmpty) {
      try {
        await clearAIChatHistoryUseCase(sessionId);
        debugPrint('[AIChatBloc] Cleared chat history for session: $sessionId');
      } catch (e) {
        debugPrint('[AIChatBloc] Error clearing chat history: $e');
      }
    }
    // Reset state to clear all messages from UI
    _typingTimer?.cancel();
    emit(const AIChatInitial());
  }

  void _onStopStreaming(StopStreaming event, Emitter<AIChatState> emit) {
    _typingTimer?.cancel();

    if (state is AIChatStreaming) {
      final currentState = state as AIChatStreaming;
      final messages = currentState.messages.toList();

      if (messages.isNotEmpty) {
        // Complete with current partial text
        final currentText = messages.last.text;
        messages[messages.length - 1] = AIChatMessage(
          text: currentText.isEmpty ? '(Đã dừng)' : currentText,
          isUser: false,
          sender: 'AI',
          isStreaming: false,
          sources: _pendingSources,
        );
      }

      emit(AIChatLoaded(messages: messages, sessionId: currentState.sessionId));
    }
  }

  void _onResetChat(ResetAIChat event, Emitter<AIChatState> emit) {
    _typingTimer?.cancel();
    emit(const AIChatInitial());
  }
}
