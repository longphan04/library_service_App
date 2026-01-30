import '../entities/book.dart';
import '../entities/pagination.dart';
import '../repositories/book_repository.dart';

class GetBooksByIdUseCase {
  final BookRepository repository;

  GetBooksByIdUseCase(this.repository);

  Future<List<Book>> call(List<String> ids) {
    return repository.getBooksById(ids);
  }
}

class GetBookDetailsUseCase {
  final BookRepository repository;

  GetBookDetailsUseCase(this.repository);

  Future<Book> call(int bookId) {
    return repository.getBookDetails(bookId);
  }
}

class GetAllBooksUseCase {
  final BookRepository repository;

  GetAllBooksUseCase(this.repository);

  Future<(List<Book>, Pagination)> call({
    String? query,
    String? categoryId,
    String? sort,
    int? page,
    int? limit,
  }) {
    return repository.getAllBooks(query, categoryId, sort, page, limit);
  }
}

class SearchBooksUseCase {
  final BookRepository repository;

  SearchBooksUseCase(this.repository);

  Future<List<String>> call(String query) {
    if (query.isEmpty) {
      return Future.value([]);
    }
    return repository.getSuggestions(query);
  }
}

class GetRecommendedBooksUseCase {
  final BookRepository repository;

  GetRecommendedBooksUseCase(this.repository);

  Future<List<Book>> call() {
    return repository.getRecommendedBooks();
  }
}
