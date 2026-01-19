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
