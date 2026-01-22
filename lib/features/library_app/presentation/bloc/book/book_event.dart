part of 'book_bloc.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();
  @override
  List<Object?> get props => [];
}

// ================== EVENTS CHO LIST / SEARCH / FILTER ==================

class LoadBooksEvent extends BookEvent {
  final int page;
  final int limit;
  // Các tham số filter
  final String? query;
  final String? categoryId;
  final String? sort; // 'newest', 'popular', etc.

  const LoadBooksEvent({
    this.page = 1,
    this.limit = 10,
    this.query,
    this.categoryId,
    this.sort,
  });

  @override
  List<Object?> get props => [page, limit, query, categoryId, sort];
}

class LoadMoreBooksEvent extends BookEvent {
  @override
  List<Object?> get props => [];
}

class RefreshBooksEvent extends BookEvent {
  @override
  List<Object?> get props => [];
}

// ================== EVENTS CHO DETAIL ==================

class LoadBookDetailEvent extends BookEvent {
  final int bookId;
  const LoadBookDetailEvent(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class RefreshBookDetailEvent extends BookEvent {
  // Cần truyền ID hoặc lấy từ state cũ, ở đây mình giữ nguyên logic cũ của bạn
  // là lấy từ state nên không cần truyền param
  @override
  List<Object?> get props => [];
}
