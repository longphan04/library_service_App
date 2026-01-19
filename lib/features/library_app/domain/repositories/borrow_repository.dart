import '../entities/book_hold.dart';

abstract class BorrowRepository {
  Future<List<BookHold>> getBookHolds();
  Future<void> addBookHold(int bookId);
  Future<List<int>> removeBookHold(int holdId);
}
