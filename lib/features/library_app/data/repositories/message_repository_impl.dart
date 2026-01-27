import '../../domain/entities/ai_chat_response.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/remote/message_remote_datasource.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;

  MessageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AIChatResponse> sendMessage({
    required String message,
    String? sessionId,
    int topK = 5,
  }) async {
    final responseModel = await remoteDataSource.sendMessage(
      message: message,
      sessionId: sessionId,
      topK: topK,
    );
    return responseModel.toEntity();
  }

  @override
  Future<void> clearChatHistory(String sessionId) async {
    await remoteDataSource.clearChatHistory(sessionId);
  }

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
