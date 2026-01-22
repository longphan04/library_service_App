import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/notification.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  @JsonKey(name: 'notification_id')
  final int notificationId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'content')
  final String content;
  @JsonKey(name: 'reference_id')
  final int? referenceId;
  @JsonKey(name: 'is_read')
  final bool isRead;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.title,
    required this.content,
    this.referenceId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  Notification toEntity() {
    return Notification(
      notificationId: notificationId,
      userId: userId,
      type: type,
      title: title,
      content: content,
      referenceId: referenceId ?? 0,
      isRead: isRead,
      createdAt: createdAt.add(Duration(hours: 7)),
    );
  }
}
