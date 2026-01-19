import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/error_handler.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/entities/pagination.dart';
import '../../../domain/usecases/book_usecase.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetAllBooksUseCase getAllBooksUseCase;

  BookBloc(this.getAllBooksUseCase) : super(BookInitial()) {
    on<LoadBooksEvent>(_onLoadBooks);
    on<LoadMoreBooksEvent>(_onLoadMoreBooks);
  }

  Future<void> _onLoadBooks(
    LoadBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    if (state is ListBooksLoaded) {
      return;
    }
    emit(ListBooksLoading());
    try {
      final result = await getAllBooksUseCase();
      emit(ListBooksLoaded(result.$1, result.$2));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(ListBooksFailure(error, e));
    } catch (e) {
      emit(ListBooksFailure('Lỗi khi load danh sách sách', e));
    }
  }

  Future<void> _onLoadMoreBooks(
    LoadMoreBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    if (state is ListBooksLoaded) {
      final currentState = state as ListBooksLoaded;

      // Don't load if no more pages
      if (currentState.pagination.currentPage >=
          currentState.pagination.totalPages) {
        return;
      }

      emit(ListBooksLoadingMore(currentState.books, currentState.pagination));

      try {
        final result = await getAllBooksUseCase();
        final newBooks = [...currentState.books, ...result.$1];
        emit(ListBooksLoaded(newBooks, result.$2));
      } on DioException catch (_) {
        // Revert to previous state on error
        emit(currentState);
      } catch (_) {
        // Revert to previous state on error
        emit(currentState);
      }
    }
  }
}

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
