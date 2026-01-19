import 'package:equatable/equatable.dart';

import 'author.dart';
import 'category.dart';
import 'publisher.dart';
import 'shelf.dart';

class Book extends Equatable {
  final int bookId;
  final String title;
  final String? description;
  final int? publishYear;
  final String? language;
  final String? coverUrl;
  final int? totalCopies;
  final int? availableCopies;
  final Publisher? publisher;
  final Shelf? shelf;
  final List<Category>? categories;
  final List<Author>? authors;

  const Book({
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

  @override
  List<Object?> get props => [
    bookId,
    title,
    description,
    publishYear,
    language,
    coverUrl,
    totalCopies,
    availableCopies,
    publisher,
    shelf,
    categories,
    authors,
  ];
}
