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
