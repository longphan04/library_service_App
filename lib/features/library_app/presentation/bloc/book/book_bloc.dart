import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/error_handler.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/entities/pagination.dart';
import '../../../domain/usecases/book_usecase.dart'; // Chứa cả GetAll và GetDetail

part 'book_event.dart';
part 'book_state.dart';

// ============================================================================
// 1. BOOK BLOC (Xử lý Danh sách, Tìm kiếm, Filter, Load More)
// ============================================================================
class BookBloc extends Bloc<BookEvent, BookState> {
  final GetAllBooksUseCase getAllBooksUseCase;

  BookBloc(this.getAllBooksUseCase) : super(BookInitial()) {
    on<LoadBooksEvent>(_onLoadBooks);
    on<LoadMoreBooksEvent>(_onLoadMoreBooks);
    on<RefreshBooksEvent>(_onRefreshBooks);
  }

  Future<void> _onLoadBooks(
    LoadBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(ListBooksLoading());
    try {
      final result = await getAllBooksUseCase(
        page: event.page,
        limit: event.limit,
        query: event.query,
        categoryId: event.categoryId,
        sort: event.sort,
      );
      emit(
        ListBooksLoaded(
          result.$1,
          result.$2,
          currentQuery: event.query,
          currentCategoryId: event.categoryId,
          currentSort: event.sort,
        ),
      );
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(ListBooksFailure(error, e));
    } catch (e) {
      emit(ListBooksFailure('Lỗi khi tải danh sách sách', e));
    }
  }

  Future<void> _onLoadMoreBooks(
    LoadMoreBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    if (state is! ListBooksLoaded) return;

    final currentState = state as ListBooksLoaded;
    if (currentState.pagination.currentPage >=
        currentState.pagination.totalPages) {
      return;
    }

    emit(ListBooksLoadingMore(currentState));

    try {
      final nextPage = currentState.pagination.currentPage + 1;
      final result = await getAllBooksUseCase(
        page: nextPage,
        limit: 10,
        query: currentState.currentQuery,
        categoryId: currentState.currentCategoryId,
        sort: currentState.currentSort,
      );

      final newBooks = [...currentState.books, ...result.$1];
      emit(
        ListBooksLoaded(
          newBooks,
          result.$2,
          currentQuery: currentState.currentQuery,
          currentCategoryId: currentState.currentCategoryId,
          currentSort: currentState.currentSort,
        ),
      );
    } catch (e) {
      emit(currentState); // Revert state nếu lỗi
    }
  }

  Future<void> _onRefreshBooks(
    RefreshBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    if (state is ListBooksLoaded) {
      final currentState = state as ListBooksLoaded;
      add(
        LoadBooksEvent(
          page: 1,
          query: currentState.currentQuery,
          categoryId: currentState.currentCategoryId,
          sort: currentState.currentSort,
        ),
      );
    } else {
      add(const LoadBooksEvent(page: 1));
    }
  }
}

// ============================================================================
// 2. BOOK DETAIL BLOC (Xử lý Chi tiết sách)
// ============================================================================
class BookDetailBloc extends Bloc<BookEvent, BookState> {
  final GetBookDetailsUseCase getBookDetailUseCase;

  BookDetailBloc(this.getBookDetailUseCase) : super(BookInitial()) {
    on<LoadBookDetailEvent>(_onLoadBookDetail);
    on<RefreshBookDetailEvent>(_onRefreshBookDetail);
  }

  Future<void> _onLoadBookDetail(
    LoadBookDetailEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(BookDetailLoading());
    try {
      final bookDetail = await getBookDetailUseCase(event.bookId);
      emit(BookDetailLoaded(bookDetail));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(BookDetailFailure(error, e));
    } catch (e) {
      emit(BookDetailFailure('Lỗi khi tải chi tiết sách: $e', e));
    }
  }

  Future<void> _onRefreshBookDetail(
    RefreshBookDetailEvent event,
    Emitter<BookState> emit,
  ) async {
    if (state is BookDetailLoaded) {
      final currentBookDetail = (state as BookDetailLoaded).bookDetail;
      try {
        final refreshedBookDetail = await getBookDetailUseCase(
          currentBookDetail.bookId,
        );
        emit(BookDetailLoaded(refreshedBookDetail));
      } on DioException catch (e) {
        final error = ErrorHandler.getErrorMessage(e);
        emit(BookDetailFailure(error, e));
      } catch (e) {
        emit(BookDetailFailure('Lỗi khi làm mới chi tiết sách', e));
      }
    }
  }
}
