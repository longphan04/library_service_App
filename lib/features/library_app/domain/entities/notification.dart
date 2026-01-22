import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final int notificationId;
  final int userId;
  final String type;
  final String title;
  final String content;
  final int? referenceId;
  final bool isRead;
  final DateTime createdAt;
  const Notification({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.title,
    required this.content,
    this.referenceId,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    notificationId,
    userId,
    type,
    title,
    content,
    referenceId,
    isRead,
    createdAt,
  ];
}
