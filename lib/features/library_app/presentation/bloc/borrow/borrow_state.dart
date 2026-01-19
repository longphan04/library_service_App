part of 'borrow_bloc.dart';

abstract class BorrowState extends Equatable {
  const BorrowState();

  @override
  List<Object> get props => [];
}

class BorrowInitial extends BorrowState {
  @override
  List<Object> get props => [];
}

class ListBookHoldsLoading extends BorrowState {
  @override
  List<Object> get props => [];
}

class ListBookHoldsLoaded extends BorrowState {
  final List<BookHold> holds;

  const ListBookHoldsLoaded(this.holds);

  @override
  List<Object> get props => [holds];
}

class ListBookHoldsFailure extends BorrowState {
  final String message;
  final Object error;

  const ListBookHoldsFailure(this.message, this.error);
  @override
  List<Object> get props => [message, error];
}

class AddBookHoldLoading extends BorrowState {
  @override
  List<Object> get props => [];
}

class AddBookHoldSuccess extends BorrowState {
  @override
  List<Object> get props => [];
}

class AddBookHoldFailure extends BorrowState {
  final String message;
  final Object error;

  const AddBookHoldFailure(this.message, this.error);
  @override
  List<Object> get props => [message, error];
}
