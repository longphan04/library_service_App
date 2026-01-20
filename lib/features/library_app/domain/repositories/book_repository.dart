import '../entities/book.dart';
import '../entities/pagination.dart';

abstract class BookRepository {
  Future<Book> getBookDetails(int bookId);
  Future<(List<Book>, Pagination)> getAllBooks();
  Future<List<String>> getSuggestions(String query);
}
