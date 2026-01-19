// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shelf_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShelfModel _$ShelfModelFromJson(Map<String, dynamic> json) => ShelfModel(
  shelfId: (json['shelf_id'] as num).toInt(),
  code: json['code'] as String,
);

Map<String, dynamic> _$ShelfModelToJson(ShelfModel instance) =>
    <String, dynamic>{'shelf_id': instance.shelfId, 'code': instance.code};
