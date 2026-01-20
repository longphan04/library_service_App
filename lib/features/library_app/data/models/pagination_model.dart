import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/pagination.dart';

part 'pagination_model.g.dart';

@JsonSerializable()
class PaginationModel {
  @JsonKey(name: 'page')
  final int page;
  @JsonKey(name: 'limit')
  final int limit;
  @JsonKey(name: 'totalItems')
  final int totalItems;
  @JsonKey(name: 'totalPages')
  final int totalPages;
  @JsonKey(name: 'hasNext')
  final bool hasNext;

  const PaginationModel({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  Pagination toEntity() {
    return Pagination(
      currentPage: page,
      totalPages: totalPages,
      pageSize: limit,
      totalItems: totalItems,
    );
  }
}
