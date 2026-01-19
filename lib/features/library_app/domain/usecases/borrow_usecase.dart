import '../entities/book_hold.dart';
import '../repositories/borrow_repository.dart';

class GetBookHoldsUseCase {
  final BorrowRepository repository;

  GetBookHoldsUseCase(this.repository);

  Future<List<BookHold>> call() {
    return repository.getBookHolds();
  }
}

class AddBookHoldUseCase {
  final BorrowRepository repository;

  AddBookHoldUseCase(this.repository);

  Future<void> call(int holdId) {
    return repository.addBookHold(holdId);
  }
}
