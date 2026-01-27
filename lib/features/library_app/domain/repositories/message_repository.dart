import '../entities/ai_chat_response.dart';
import '../entities/notification.dart';

abstract class MessageRepository {
  // Notifications
  Future<List<Notification>> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAllAsRead();

  // AI Chat
  Future<AIChatResponse> sendMessage({
    required String message,
    String? sessionId,
    int topK = 5,
  });

  Future<void> clearChatHistory(String sessionId);
}
