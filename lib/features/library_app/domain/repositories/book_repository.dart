import '../entities/book.dart';
import '../entities/pagination.dart';

abstract class BookRepository {
  Future<Book> getBookById(String id);
  Future<Book> getBookDetails(int bookId);
  Future<(List<Book>, Pagination)> getAllBooks(
    String? query,
    String? categoryId,
    String? sort,
    int? page,
    int? limit,
  );
  Future<List<String>> getSuggestions(String query);
  Future<List<Book>> getRecommendedBooks();
}
