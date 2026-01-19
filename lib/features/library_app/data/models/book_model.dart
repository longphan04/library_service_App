import 'package:json_annotation/json_annotation.dart';

import '../../../../core/config/dio_config.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/pagination.dart';
import 'author_model.dart';
import 'category_model.dart';
import 'publisher_model.dart';
import 'shelf_model.dart';

part 'book_model.g.dart';

@JsonSerializable()
class BookModel {
  @JsonKey(name: 'book_id')
  final int bookId;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'publish_year')
  final int? publishYear;
  @JsonKey(name: 'language')
  final String? language;
  @JsonKey(name: 'cover_url')
  final String? coverUrl;
  @JsonKey(name: 'total_copies')
  final int? totalCopies;
  @JsonKey(name: 'available_copies')
  final int? availableCopies;
  @JsonKey(name: 'publisher')
  final PublisherModel? publisher;
  @JsonKey(name: 'shelf')
  final ShelfModel? shelf;
  @JsonKey(name: 'categories')
  final List<CategoryModel>? categories;
  @JsonKey(name: 'authors')
  final List<AuthorModel>? authors;

  const BookModel({
    required this.bookId,
    required this.title,
    this.description,
    this.publishYear,
    this.language,
    this.coverUrl,
    this.totalCopies,
    this.availableCopies,
    this.publisher,
    this.shelf,
    this.categories,
    this.authors,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookModelToJson(this);

  Book toEntity() {
    return Book(
      bookId: bookId,
      title: title,
      description: description,
      publishYear: publishYear,
      language: language,
      coverUrl: coverUrl != null
          ? '${DioConfig.baseUrl}/public/$coverUrl'
          : null,
      totalCopies: totalCopies,
      availableCopies: availableCopies,
      publisher: publisher?.toEntity(),
      shelf: shelf?.toEntity(),
      categories: categories?.map((c) => c.toEntity()).toList(),
      authors: authors?.map((a) => a.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class BooksListModel {
  @JsonKey(name: 'data')
  final List<BookModel> data;
  @JsonKey(name: 'pagination')
  final PaginationModel pagination;

  const BooksListModel({required this.data, required this.pagination});
  factory BooksListModel.fromJson(Map<String, dynamic> json) =>
      _$BooksListModelFromJson(json);

  Map<String, dynamic> toJson() => _$BooksListModelToJson(this);
}

/// Pagination model
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
