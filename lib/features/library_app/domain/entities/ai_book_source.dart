import 'package:equatable/equatable.dart';
import 'author.dart';
import 'book.dart';
import 'category.dart';

class AIBookSource extends Equatable {
  final String title;
  final String authors;
  final String category;
  final String identifier;
  final String publishYear;
  final String richtext;
  final double score;

  const AIBookSource({
    required this.title,
    required this.authors,
    required this.category,
    required this.identifier,
    required this.publishYear,
    required this.richtext,
    required this.score,
  });

  /// Convert to Book entity for BookCard
  Book toBook() {
    final bookId = identifier.isNotEmpty ? identifier.hashCode : title.hashCode;

    return Book(
      bookId: bookId,
      title: title,
      publishYear: int.tryParse(publishYear),
      authors: authors.isNotEmpty ? [Author(authorId: 0, name: authors)] : null,
      categories: category.isNotEmpty
          ? [Category(categoryId: 0, name: category, bookCount: 0)]
          : null,
    );
  }

  @override
  List<Object?> get props => [
    title,
    authors,
    category,
    identifier,
    publishYear,
    richtext,
    score,
  ];
}
