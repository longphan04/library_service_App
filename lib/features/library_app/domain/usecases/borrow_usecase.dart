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

class BorrowNowUseCase {
  final BorrowRepository repository;

  BorrowNowUseCase(this.repository);

  Future<void> call(int bookId) {
    return repository.borrowNow(bookId);
  }
}

class BorrowFromHoldsUseCase {
  final BorrowRepository repository;

  BorrowFromHoldsUseCase(this.repository);

  Future<void> call(List<int> holdIds) {
    return repository.borrowFromHolds(holdIds);
  }
}

class RemoveBookHoldUseCase {
  final BorrowRepository repository;

  RemoveBookHoldUseCase(this.repository);

  Future<void> call(List<int> holdIds) {
    return repository.removeBookHold(holdIds);
  }
}
