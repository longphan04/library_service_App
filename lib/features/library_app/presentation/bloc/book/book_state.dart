part of 'book_bloc.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {
  @override
  List<Object?> get props => [];
}

class ListBooksLoading extends BookState {
  @override
  List<Object?> get props => [];
}

class BookDetailLoading extends BookState {
  @override
  List<Object?> get props => [];
}

class ListBooksLoaded extends BookState {
  final List<Book> books;
  final Pagination pagination;

  const ListBooksLoaded(this.books, this.pagination);

  @override
  List<Object?> get props => [books, pagination];
}

class ListBooksLoadingMore extends BookState {
  final List<Book> currentBooks;
  final Pagination pagination;

  const ListBooksLoadingMore(this.currentBooks, this.pagination);

  @override
  List<Object?> get props => [currentBooks, pagination];
}

class BookDetailLoaded extends BookState {
  final Book bookDetail;

  const BookDetailLoaded(this.bookDetail);

  @override
  List<Object?> get props => [bookDetail];
}

class ListBooksFailure extends BookState {
  final String message;
  final dynamic error;
  const ListBooksFailure(this.message, this.error);

  @override
  List<Object?> get props => [message, error];
}

class BookDetailFailure extends BookState {
  final String message;
  final dynamic error;
  const BookDetailFailure(this.message, this.error);

  @override
  List<Object?> get props => [message, error];
}
