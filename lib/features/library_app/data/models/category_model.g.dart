// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      categoryId: (json['category_id'] as num).toInt(),
      name: json['name'] as String,
      image: json['image'] as String?,
      bookCount: (json['bookCount'] as num?)?.toInt(),
      totalBorrows: (json['totalBorrows'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'name': instance.name,
      'image': instance.image,
      'bookCount': instance.bookCount,
      'totalBorrows': instance.totalBorrows,
    };
