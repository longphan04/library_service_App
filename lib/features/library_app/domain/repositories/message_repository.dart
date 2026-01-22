import '../entities/notification.dart';

abstract class MessageRepository {
  Future<List<Notification>> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAllAsRead();
}
