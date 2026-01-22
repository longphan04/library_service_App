import 'package:json_annotation/json_annotation.dart';

import '../../../../core/config/dio_config.dart';
import '../../domain/entities/category.dart';

part 'category_model.g.dart';

/// Category model for API deserialization
@JsonSerializable()
class CategoryModel {
  @JsonKey(name: 'category_id')
  final int categoryId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'image')
  final String? image;
  @JsonKey(name: 'bookCount')
  final int? bookCount;
  @JsonKey(name: 'totalBorrows')
  final int? totalBorrows;

  const CategoryModel({
    required this.categoryId,
    required this.name,
    this.image,
    this.bookCount,
    this.totalBorrows,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  Category toEntity() {
    return Category(
      categoryId: categoryId,
      name: name,
      image: '${DioConfig.baseUrl}/public/${image ?? ''}',
      bookCount: bookCount ?? 0,
      totalBorrows: totalBorrows ?? 0,
    );
  }
}
