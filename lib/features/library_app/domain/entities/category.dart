import 'package:equatable/equatable.dart';

/// Category entity for book classification
/// Corresponds to `categories` table in database
class Category extends Equatable {
  final int categoryId;
  final String name;
  final String? image;
  final int bookCount;

  const Category({
    required this.categoryId,
    required this.name,
    this.image,
    required this.bookCount,
  });

  @override
  List<Object?> get props => [categoryId, name, image, bookCount];
}
