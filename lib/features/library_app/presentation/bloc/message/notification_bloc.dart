import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/error_handler.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/usecases/message_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final GetUnreadCountUseCase getUnreadCountUseCase;
  final MarkAllAsReadUseCase markAllAsReadUseCase;

  Timer? _unreadCountTimer;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.getUnreadCountUseCase,
    required this.markAllAsReadUseCase,
  }) : super(const NotificationInitial()) {
    on<FetchNotifications>(_onFetchNotifications);
    on<RefreshNotifications>(_onRefreshNotifications);
    on<FetchUnreadCount>(_onFetchUnreadCount);
    on<MarkAllNotificationsAsRead>(_onMarkAllAsRead);
    on<StartUnreadCountPolling>(_onStartPolling);
    on<StopUnreadCountPolling>(_onStopPolling);
  }

  @override
  Future<void> close() {
    _unreadCountTimer?.cancel();
    return super.close();
  }

  void _onStartPolling(
    StartUnreadCountPolling event,
    Emitter<NotificationState> emit,
  ) {
    // Fetch ngay lập tức
    add(const FetchUnreadCount());

    // Sau đó poll mỗi 5 giây
    _unreadCountTimer?.cancel();
    _unreadCountTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => add(const FetchUnreadCount()),
    );
  }

  void _onStopPolling(
    StopUnreadCountPolling event,
    Emitter<NotificationState> emit,
  ) {
    _unreadCountTimer?.cancel();
    _unreadCountTimer = null;
  }

  Future<void> _onFetchUnreadCount(
    FetchUnreadCount event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final count = await getUnreadCountUseCase();
      emit(state.copyWithUnreadCount(count));
    } catch (e) {
      // Silently fail - không cần hiển thị lỗi
    }
  }

  Future<void> _onFetchNotifications(
    FetchNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading(unreadCount: state.unreadCount));
    try {
      final notifications = await getNotificationsUseCase();
      emit(
        NotificationLoaded(
          notifications: notifications,
          unreadCount: state.unreadCount,
        ),
      );
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(
        NotificationError(
          message: error,
          error: e,
          unreadCount: state.unreadCount,
        ),
      );
    } catch (e) {
      emit(
        NotificationError(
          message: 'Đã xảy ra lỗi không xác định',
          error: e,
          unreadCount: state.unreadCount,
        ),
      );
    }
  }

  Future<void> _onRefreshNotifications(
    RefreshNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final notifications = await getNotificationsUseCase();
      final count = await getUnreadCountUseCase();
      emit(
        NotificationLoaded(notifications: notifications, unreadCount: count),
      );
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(
        NotificationError(
          message: error,
          error: e,
          unreadCount: state.unreadCount,
        ),
      );
    } catch (e) {
      emit(
        NotificationError(
          message: 'Đã xảy ra lỗi không xác định',
          error: e,
          unreadCount: state.unreadCount,
        ),
      );
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await markAllAsReadUseCase();
      // Cập nhật unread count về 0 ngay lập tức
      emit(state.copyWithUnreadCount(0));
    } catch (e) {
      // Silently fail
    }
  }
}
