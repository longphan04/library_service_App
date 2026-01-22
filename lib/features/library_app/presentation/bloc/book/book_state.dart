part of 'book_bloc.dart';

abstract class BookState extends Equatable {
  const BookState();
  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

// ================== STATES CHO LIST ==================

class ListBooksLoading extends BookState {}

class ListBooksLoaded extends BookState {
  final List<Book> books;
  final Pagination pagination;

  // Lưu filter để dùng cho LoadMore
  final String? currentQuery;
  final String? currentCategoryId;
  final String? currentSort;

  const ListBooksLoaded(
    this.books,
    this.pagination, {
    this.currentQuery,
    this.currentCategoryId,
    this.currentSort,
  });

  @override
  List<Object?> get props => [
    books,
    pagination,
    currentQuery,
    currentCategoryId,
    currentSort,
  ];
}

class ListBooksLoadingMore extends BookState {
  final ListBooksLoaded previousState; // Giữ lại data cũ để hiển thị
  const ListBooksLoadingMore(this.previousState);

  @override
  List<Object?> get props => [previousState];
}

class ListBooksFailure extends BookState {
  final String message;
  final dynamic error;
  const ListBooksFailure(this.message, this.error);

  @override
  List<Object?> get props => [message, error];
}

// ================== STATES CHO DETAIL ==================

class BookDetailLoading extends BookState {}

class BookDetailLoaded extends BookState {
  final Book bookDetail;
  const BookDetailLoaded(this.bookDetail);

  @override
  List<Object?> get props => [bookDetail];
}

class BookDetailFailure extends BookState {
  final String message;
  final dynamic error;
  const BookDetailFailure(this.message, this.error);

  @override
  List<Object?> get props => [message, error];
}
