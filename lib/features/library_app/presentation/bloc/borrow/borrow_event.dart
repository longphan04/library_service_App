part of 'borrow_bloc.dart';

abstract class BorrowEvent extends Equatable {
  const BorrowEvent();

  @override
  List<Object> get props => [];
}

class LoadBookHoldsEvent extends BorrowEvent {
  @override
  List<Object> get props => [];
}

class RefreshBookHoldsEvent extends BorrowEvent {
  @override
  List<Object> get props => [];
}

class AddBookHoldEvent extends BorrowEvent {
  final int holdId;

  const AddBookHoldEvent(this.holdId);

  @override
  List<Object> get props => [holdId];
}

class RemoveBookHoldEvent extends BorrowEvent {
  final List<int> holdIds;

  const RemoveBookHoldEvent(this.holdIds);

  @override
  List<Object> get props => [holdIds];
}

class BorrowNowEvent extends BorrowEvent {
  final int bookId;

  const BorrowNowEvent(this.bookId);

  @override
  List<Object> get props => [bookId];
}

class BorrowFromHoldsEvent extends BorrowEvent {
  final List<int> holdIds;

  const BorrowFromHoldsEvent(this.holdIds);

  @override
  List<Object> get props => [holdIds];
}
