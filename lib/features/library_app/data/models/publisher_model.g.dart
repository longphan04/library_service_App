// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publisher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublisherModel _$PublisherModelFromJson(Map<String, dynamic> json) =>
    PublisherModel(
      publisherId: (json['publisher_id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$PublisherModelToJson(PublisherModel instance) =>
    <String, dynamic>{
      'publisher_id': instance.publisherId,
      'name': instance.name,
    };
