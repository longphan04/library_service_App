import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/error_handler.dart';
import '../../../domain/entities/book_hold.dart';
import '../../../domain/usecases/borrow_usecase.dart';

part 'borrow_event.dart';
part 'borrow_state.dart';

class BorrowBloc extends Bloc<BorrowEvent, BorrowState> {
  final GetBookHoldsUseCase getBookHoldsUseCase;
  final AddBookHoldUseCase addBookHoldUseCase;

  BorrowBloc(this.getBookHoldsUseCase, this.addBookHoldUseCase)
    : super(BorrowInitial()) {
    on<LoadBookHoldsEvent>(_onLoadBookHolds);
    on<RefreshBookHoldsEvent>(_onRefreshBookHolds);
    on<AddBookHoldEvent>(_onAddBookHold);
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
}
