// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_hold_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookHoldModel _$BookHoldModelFromJson(Map<String, dynamic> json) =>
    BookHoldModel(
      holdId: (json['hold_id'] as num).toInt(),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      copy: HoldCopyModel.fromJson(json['copy'] as Map<String, dynamic>),
      book: BookModel.fromJson(json['book'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookHoldModelToJson(BookHoldModel instance) =>
    <String, dynamic>{
      'hold_id': instance.holdId,
      'expires_at': instance.expiresAt.toIso8601String(),
      'copy': instance.copy,
      'book': instance.book,
    };

HoldCopyModel _$HoldCopyModelFromJson(Map<String, dynamic> json) =>
    HoldCopyModel(
      copyId: (json['copy_id'] as num).toInt(),
      note: json['note'] as String,
    );

Map<String, dynamic> _$HoldCopyModelToJson(HoldCopyModel instance) =>
    <String, dynamic>{'copy_id': instance.copyId, 'note': instance.note};
