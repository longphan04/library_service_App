import 'package:equatable/equatable.dart';

/// Book image entity for additional book images
/// Corresponds to `book_images` table in database
class BookImage extends Equatable {
  final int imageId;
  final int bookId;
  final String imageUrl;
  final int sortOrder;
  final DateTime createdAt;

  const BookImage({
    required this.imageId,
    required this.bookId,
    required this.imageUrl,
    required this.sortOrder,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [imageId, bookId, imageUrl, sortOrder, createdAt];
}
