// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      notificationId: (json['notification_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      type: json['type'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      referenceId: (json['reference_id'] as num?)?.toInt(),
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'notification_id': instance.notificationId,
      'user_id': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'content': instance.content,
      'reference_id': instance.referenceId,
      'is_read': instance.isRead,
      'created_at': instance.createdAt.toIso8601String(),
    };
