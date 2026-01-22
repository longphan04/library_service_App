import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int categoryId;
  final String name;
  final String? image;
  final int bookCount;
  final int? totalBorrows;

  const Category({
    required this.categoryId,
    required this.name,
    this.image,
    required this.bookCount,
    this.totalBorrows,
  });

  @override
  List<Object?> get props => [categoryId, name, image, bookCount, totalBorrows];
}
