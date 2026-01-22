part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  final int unreadCount;

  const NotificationState({this.unreadCount = 0});

  NotificationState copyWithUnreadCount(int count);

  @override
  List<Object> get props => [unreadCount];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial({super.unreadCount = 0});

  @override
  NotificationState copyWithUnreadCount(int count) {
    return NotificationInitial(unreadCount: count);
  }
}

class NotificationLoading extends NotificationState {
  const NotificationLoading({super.unreadCount = 0});

  @override
  NotificationState copyWithUnreadCount(int count) {
    return NotificationLoading(unreadCount: count);
  }
}

class NotificationLoaded extends NotificationState {
  final List<Notification> notifications;

  const NotificationLoaded({
    required this.notifications,
    super.unreadCount = 0,
  });

  @override
  NotificationState copyWithUnreadCount(int count) {
    return NotificationLoaded(notifications: notifications, unreadCount: count);
  }

  @override
  List<Object> get props => [notifications, unreadCount];
}

class NotificationError extends NotificationState {
  final String message;
  final dynamic error;

  const NotificationError({
    required this.message,
    this.error,
    super.unreadCount = 0,
  });

  @override
  NotificationState copyWithUnreadCount(int count) {
    return NotificationError(
      message: message,
      error: error,
      unreadCount: count,
    );
  }

  @override
  List<Object> get props => [message, error, unreadCount];
}
