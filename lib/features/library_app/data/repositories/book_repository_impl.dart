import '../../domain/entities/book.dart';
import '../../domain/entities/pagination.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/remote/book_remote_datasource.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDatasource remoteDataSource;

  BookRepositoryImpl({required this.remoteDataSource});

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
  Future<(List<Book>, Pagination)> getAllBooks() async {
    try {
      final booksListModel = await remoteDataSource.getAllBooks();
      final books = booksListModel.data
          .map((model) => model.toEntity())
          .toList();
      final pagination = booksListModel.pagination.toEntity();
      return (books, pagination);
    } catch (e) {
      rethrow;
    }
  }
}
