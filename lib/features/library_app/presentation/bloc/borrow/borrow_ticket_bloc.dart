import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/error_handler.dart';
import '../../../domain/entities/borrow_ticket.dart';
import '../../../domain/entities/pagination.dart';
import '../../../domain/usecases/borrow_ticket_usecase.dart';

part 'borrow_ticket_event.dart';
part 'borrow_ticket_state.dart';

class BorrowTicketListBloc extends Bloc<BorrowTicketEvent, BorrowTicketState> {
  final GetBorrowTicketsUseCase getBorrowTicketsUseCase;
  final CancelBorrowTicketUseCase cancelBorrowTicketUseCase;
  final RenewBorrowTicketUseCase renewBorrowTicketUseCase;

  BorrowTicketListBloc(
    this.getBorrowTicketsUseCase,
    this.cancelBorrowTicketUseCase,
    this.renewBorrowTicketUseCase,
  ) : super(BorrowTicketInitial()) {
    on<LoadBorrowTicketsEvent>(_onLoadBorrowTickets);
    on<RefreshBorrowTicketsEvent>(_onRefreshBorrowTickets);
    on<CancelBorrowTicketEvent>(_onCancelBorrowTicket);
    on<RenewBorrowTicketEvent>(_onRenewBorrowTicket);
  }

  Future<void> _onCancelBorrowTicket(
    CancelBorrowTicketEvent event,
    Emitter<BorrowTicketState> emit,
  ) async {
    try {
      await cancelBorrowTicketUseCase(event.ticketId);
      add(RefreshBorrowTicketsEvent());
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      print('Lỗi khi hủy phiếu mượn: $error');
    } catch (e) {
      print('Lỗi khi hủy phiếu mượn: $e');
    }
  }

  Future<void> _onRenewBorrowTicket(
    RenewBorrowTicketEvent event,
    Emitter<BorrowTicketState> emit,
  ) async {
    try {
      await renewBorrowTicketUseCase(event.ticketId);
      add(RefreshBorrowTicketsEvent());
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      print('Lỗi khi gia hạn phiếu mượn: $error');
    } catch (e) {
      print('Lỗi khi gia hạn phiếu mượn: $e');
    }
  }

  Future<void> _onLoadBorrowTickets(
    LoadBorrowTicketsEvent event,
    Emitter<BorrowTicketState> emit,
  ) async {
    emit(BorrowTicketListLoading());
    try {
      final (tickets, pagination) = await getBorrowTicketsUseCase();
      emit(BorrowTicketListLoaded(tickets, pagination));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(BorrowTicketListFailure(error, e));
    } catch (e) {
      print('Lỗi khi load lịch sử mượn sách: $e');
      emit(BorrowTicketListFailure('Lỗi khi load lịch sử mượn sách', e));
    }
  }

  Future<void> _onRefreshBorrowTickets(
    RefreshBorrowTicketsEvent event,
    Emitter<BorrowTicketState> emit,
  ) async {
    try {
      final (tickets, pagination) = await getBorrowTicketsUseCase();
      emit(BorrowTicketListLoaded(tickets, pagination));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(BorrowTicketListFailure(error, e));
    } catch (e) {
      emit(BorrowTicketListFailure('Lỗi khi load lịch sử mượn sách', e));
    }
  }
}

class BorrowTicketBloc extends Bloc<BorrowTicketEvent, BorrowTicketState> {
  final GetBorrowTicketDetailUseCase getBorrowTicketDetailUseCase;
  BorrowTicketBloc(this.getBorrowTicketDetailUseCase)
    : super(BorrowTicketInitial()) {
    on<LoadBorrowTicketDetailEvent>(_onLoadBorrowTicketDetail);
    on<RefreshBorrowTicketDetailEvent>(_onRefreshBorrowTicketDetail);
  }

  Future<void> _onLoadBorrowTicketDetail(
    LoadBorrowTicketDetailEvent event,
    Emitter<BorrowTicketState> emit,
  ) async {
    emit(BorrowTicketDetailLoading());
    try {
      final ticketDetail = await getBorrowTicketDetailUseCase(event.ticketId);
      emit(BorrowTicketDetailLoaded(ticketDetail));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(BorrowTicketDetailFailure(error, e));
    } catch (e) {
      emit(BorrowTicketDetailFailure('Lỗi khi load chi tiết phiếu mượn', e));
    }
  }

  Future<void> _onRefreshBorrowTicketDetail(
    RefreshBorrowTicketDetailEvent event,
    Emitter<BorrowTicketState> emit,
  ) async {
    try {
      final ticketDetail = await getBorrowTicketDetailUseCase(event.ticketId);
      emit(BorrowTicketDetailLoaded(ticketDetail));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(BorrowTicketDetailFailure(error, e));
    } catch (e) {
      emit(BorrowTicketDetailFailure('Lỗi khi load chi tiết phiếu mượn', e));
    }
  }
}
