part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class FetchNotifications extends NotificationEvent {
  const FetchNotifications();
}

class RefreshNotifications extends NotificationEvent {
  const RefreshNotifications();
}

class FetchUnreadCount extends NotificationEvent {
  const FetchUnreadCount();
}

class MarkAllNotificationsAsRead extends NotificationEvent {
  const MarkAllNotificationsAsRead();
}

class StartUnreadCountPolling extends NotificationEvent {
  const StartUnreadCountPolling();
}

class StopUnreadCountPolling extends NotificationEvent {
  const StopUnreadCountPolling();
}
