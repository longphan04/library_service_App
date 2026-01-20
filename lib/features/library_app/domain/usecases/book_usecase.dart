import '../entities/book.dart';
import '../entities/pagination.dart';
import '../repositories/book_repository.dart';

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

  Future<(List<Book>, Pagination)> call() {
    return repository.getAllBooks();
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
