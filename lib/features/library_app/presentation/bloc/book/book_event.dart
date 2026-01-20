part of 'book_bloc.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

class LoadBooksEvent extends BookEvent {
  final int page;
  final int limit;

  const LoadBooksEvent({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class LoadBookDetailEvent extends BookEvent {
  final int bookId;

  const LoadBookDetailEvent(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class RefreshBookDetailEvent extends BookEvent {
  @override
  List<Object?> get props => [];
}

class LoadMoreBooksEvent extends BookEvent {
  final int page;
  final int limit;

  const LoadMoreBooksEvent({required this.page, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class SearchQueryChanged extends BookEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class SearchCleared extends BookEvent {
  @override
  List<Object?> get props => [];
}
