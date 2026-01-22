import '../entities/notification.dart';
import '../repositories/message_repository.dart';

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
