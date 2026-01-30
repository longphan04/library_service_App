import '../../domain/entities/book.dart';
import '../../domain/entities/pagination.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/remote/book_remote_datasource.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDatasource remoteDataSource;

  BookRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Book>> getBooksById(List<String> ids) async {
    try {
      final bookModel = await remoteDataSource.getBooksById(ids);
      return bookModel.data.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Book>> getRecommendedBooks() async {
    try {
      final booksListModel = await remoteDataSource.getRecommendedBooks();
      return booksListModel.data.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Book> getBookDetails(int bookId) async {
    try {
      final bookModel = await remoteDataSource.getBookDetails(bookId);
      return bookModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(List<Book>, Pagination)> getAllBooks(
    String? query,
    String? categoryId,
    String? sort,
    int? page,
    int? limit,
  ) async {
    try {
      final booksListModel = await remoteDataSource.getAllBooks(
        query: query,
        categoryId: categoryId,
        sort: sort,
        page: page,
        limit: limit,
      );
      final books = booksListModel.data
          .map((model) => model.toEntity())
          .toList();
      final pagination = booksListModel.pagination.toEntity();
      return (books, pagination);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getSuggestions(String query) async {
    try {
      final suggestions = await remoteDataSource.getSuggestions(query);
      return suggestions.toList();
    } catch (e) {
      rethrow;
    }
  }
}
