// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookModel _$BookModelFromJson(Map<String, dynamic> json) => BookModel(
  bookId: (json['book_id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  publishYear: (json['publish_year'] as num?)?.toInt(),
  language: json['language'] as String?,
  coverUrl: json['cover_url'] as String?,
  totalCopies: (json['total_copies'] as num?)?.toInt(),
  availableCopies: (json['available_copies'] as num?)?.toInt(),
  publisher: json['publisher'] == null
      ? null
      : PublisherModel.fromJson(json['publisher'] as Map<String, dynamic>),
  shelf: json['shelf'] == null
      ? null
      : ShelfModel.fromJson(json['shelf'] as Map<String, dynamic>),
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  authors: (json['authors'] as List<dynamic>?)
      ?.map((e) => AuthorModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
  'book_id': instance.bookId,
  'title': instance.title,
  'description': instance.description,
  'publish_year': instance.publishYear,
  'language': instance.language,
  'cover_url': instance.coverUrl,
  'total_copies': instance.totalCopies,
  'available_copies': instance.availableCopies,
  'publisher': instance.publisher,
  'shelf': instance.shelf,
  'categories': instance.categories,
  'authors': instance.authors,
};

BooksListModel _$BooksListModelFromJson(Map<String, dynamic> json) =>
    BooksListModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$BooksListModelToJson(BooksListModel instance) =>
    <String, dynamic>{'data': instance.data, 'pagination': instance.pagination};

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
