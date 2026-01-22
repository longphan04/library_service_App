import '../../domain/entities/notification.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/remote/message_remote_datasource.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;

  MessageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Notification>> getNotifications() async {
    final notificationModels = await remoteDataSource.fetchNotifications();
    return notificationModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<int> getUnreadCount() async {
    return await remoteDataSource.fetchUnreadCount();
  }

  @override
  Future<void> markAllAsRead() async {
    await remoteDataSource.markAllAsRead();
  }
}
