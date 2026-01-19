import '../../domain/entities/book_hold.dart';
import '../../domain/repositories/borrow_repository.dart';
import '../datasources/remote/borrow_remote_datasource.dart';

class BorrowRepositoryImpl implements BorrowRepository {
  final BorrowRemoteDatasource remoteDatasource;

  BorrowRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<BookHold>> getBookHolds() async {
    try {
      final models = await remoteDatasource.fetchBorrowBooks();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addBookHold(int bookId) async {
    try {
      await remoteDatasource.addBookHold(bookId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<int>> removeBookHold(int holdId) {
    throw UnimplementedError();
  }
}
