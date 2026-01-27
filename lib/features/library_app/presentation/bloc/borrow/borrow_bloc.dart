import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/data_refresh_service.dart';
import '../../../../../core/utils/error_handler.dart';
import '../../../domain/entities/book_hold.dart';
import '../../../domain/usecases/borrow_usecase.dart';

part 'borrow_event.dart';
part 'borrow_state.dart';

class BorrowBloc extends Bloc<BorrowEvent, BorrowState> {
  final GetBookHoldsUseCase getBookHoldsUseCase;
  final AddBookHoldUseCase addBookHoldUseCase;
  final RemoveBookHoldUseCase removeBookHoldUseCase;
  final BorrowNowUseCase borrowNowUseCase;
  final BorrowFromHoldsUseCase borrowFromHoldsUseCase;
  StreamSubscription<void>? _refreshSubscription;

  BorrowBloc(
    this.getBookHoldsUseCase,
    this.addBookHoldUseCase,
    this.removeBookHoldUseCase,
    this.borrowNowUseCase,
    this.borrowFromHoldsUseCase,
  ) : super(BorrowInitial()) {
    on<LoadBookHoldsEvent>(_onLoadBookHolds);
    on<RefreshBookHoldsEvent>(_onRefreshBookHolds);
    on<AddBookHoldEvent>(_onAddBookHold);
    on<RemoveBookHoldEvent>(_onRemoveBookHold);
    on<BorrowNowEvent>(_onBorrowNow);
    on<BorrowFromHoldsEvent>(_onBorrowFromHolds);

    // Subscribe to book hold refresh events
    _refreshSubscription = DataRefreshService().onBookHoldRefresh.listen((_) {
      add(RefreshBookHoldsEvent());
    });
  }

  Future<void> _onLoadBookHolds(
    LoadBookHoldsEvent event,
    Emitter<BorrowState> emit,
  ) async {
    emit(ListBookHoldsLoading());
    try {
      final holds = await getBookHoldsUseCase();
      emit(ListBookHoldsLoaded(holds));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(ListBookHoldsFailure(error, e));
    } catch (e) {
      emit(ListBookHoldsFailure('Lỗi khi load danh sách đặt mượn sách', e));
    }
  }

  Future<void> _onRefreshBookHolds(
    RefreshBookHoldsEvent event,
    Emitter<BorrowState> emit,
  ) async {
    try {
      final holds = await getBookHoldsUseCase();
      emit(ListBookHoldsLoaded(holds));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(ListBookHoldsFailure(error, e));
    } catch (e) {
      emit(ListBookHoldsFailure('Lỗi khi load danh sách đặt mượn sách', e));
    }
  }

  Future<void> _onAddBookHold(
    AddBookHoldEvent event,
    Emitter<BorrowState> emit,
  ) async {
    emit(AddBookHoldLoading());
    try {
      await addBookHoldUseCase(event.holdId);
      emit(AddBookHoldSuccess());
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(AddBookHoldFailure(error, e));
    } catch (e) {
      emit(AddBookHoldFailure('Lỗi khi thêm đặt mượn sách', e));
    }
  }

  Future<void> _onRemoveBookHold(
    RemoveBookHoldEvent event,
    Emitter<BorrowState> emit,
  ) async {
    try {
      await removeBookHoldUseCase(event.holdIds);
      if (state is ListBookHoldsLoaded) {
        final currentHolds = (state as ListBookHoldsLoaded).holds;
        final updatedHolds = currentHolds
            .where((hold) => !event.holdIds.contains(hold.holdId))
            .toList();
        emit(ListBookHoldsLoaded(updatedHolds));
      } else {
        emit(RemoveBookHoldSuccess());
      }
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(RemoveBookHoldFailure(error, e));
    } catch (e) {
      emit(RemoveBookHoldFailure('Lỗi khi xóa sách trong kệ', e));
    }
  }

  Future<void> _onBorrowNow(
    BorrowNowEvent event,
    Emitter<BorrowState> emit,
  ) async {
    try {
      emit(BorrowLoading());
      await borrowNowUseCase(event.bookId);
      emit(BorrowSuccess());
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(BorrowFailure(error, e));
    } catch (e) {
      emit(BorrowFailure('Lỗi khi tạo phiếu mượn sách', e));
    }
  }

  Future<void> _onBorrowFromHolds(
    BorrowFromHoldsEvent event,
    Emitter<BorrowState> emit,
  ) async {
    try {
      emit(BorrowLoading());
      await borrowFromHoldsUseCase(event.holdIds);
      emit(BorrowSuccess());
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(BorrowFailure(error, e));
    } catch (e) {
      emit(BorrowFailure('Lỗi khi tạo phiếu mượn sách: ${e.toString()}', e));
    }
  }

  @override
  Future<void> close() {
    _refreshSubscription?.cancel();
    return super.close();
  }
}
