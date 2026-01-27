import '../entities/ai_chat_response.dart';
import '../entities/notification.dart';
import '../repositories/message_repository.dart';

class SendAIChatMessageUseCase {
  final MessageRepository repository;

  SendAIChatMessageUseCase(this.repository);

  Future<AIChatResponse> call({
    required String message,
    String? sessionId,
    int topK = 5,
  }) {
    return repository.sendMessage(
      message: message,
      sessionId: sessionId,
      topK: topK,
    );
  }
}

class ClearAIChatHistoryUseCase {
  final MessageRepository repository;

  ClearAIChatHistoryUseCase(this.repository);

  Future<void> call(String sessionId) {
    return repository.clearChatHistory(sessionId);
  }
}

class GetNotificationsUseCase {
  final MessageRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<Notification>> call() {
    return repository.getNotifications();
  }
}

class GetUnreadCountUseCase {
  final MessageRepository repository;

  GetUnreadCountUseCase(this.repository);

  Future<int> call() {
    return repository.getUnreadCount();
  }
}

class MarkAllAsReadUseCase {
  final MessageRepository repository;

  MarkAllAsReadUseCase(this.repository);

  Future<void> call() {
    return repository.markAllAsRead();
  }
}
