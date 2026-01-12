import 'package:equatable/equatable.dart';

/// Book entity (catalog/title level, not physical copy)
/// Corresponds to `books` table in database
class Book extends Equatable {
  final int bookId;
  final String isbn;
  final String title;
  final String? description;
  final int? publishYear;
  final String? language;
  final String? coverUrl;
  final int? publisherId;
  final int shelfId;
  final BookStatus status;
  final int? createdBy;
  final int? updatedBy;
  final int totalCopies;
  final int availableCopies;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Book({
    required this.bookId,
    required this.isbn,
    required this.title,
    this.description,
    this.publishYear,
    this.language,
    this.coverUrl,
    this.publisherId,
    required this.shelfId,
    required this.status,
    this.createdBy,
    this.updatedBy,
    required this.totalCopies,
    required this.availableCopies,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAvailable => availableCopies > 0;
  bool get isActive => status == BookStatus.active;

  @override
  List<Object?> get props => [
    bookId,
    isbn,
    title,
    description,
    publishYear,
    language,
    coverUrl,
    publisherId,
    shelfId,
    status,
    createdBy,
    updatedBy,
    totalCopies,
    availableCopies,
    createdAt,
    updatedAt,
  ];
}

/// Book status
enum BookStatus {
  active,
  archived;

  String get value {
    switch (this) {
      case BookStatus.active:
        return 'ACTIVE';
      case BookStatus.archived:
        return 'ARCHIVED';
    }
  }

  static BookStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'ACTIVE':
        return BookStatus.active;
      case 'ARCHIVED':
        return BookStatus.archived;
      default:
        throw ArgumentError('Invalid BookStatus: $value');
    }
  }
}
