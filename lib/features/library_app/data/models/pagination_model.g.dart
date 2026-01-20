// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      totalItems: (json['totalItems'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNext: json['hasNext'] as bool,
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'hasNext': instance.hasNext,
    };
