import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/data_refresh_service.dart';
import '../../../../../core/utils/error_handler.dart';
import '../../../domain/entities/borrow_ticket.dart';
import '../../../domain/entities/pagination.dart';
import '../../../domain/usecases/borrow_ticket_usecase.dart';

part 'borrow_ticket_event.dart';
part 'borrow_ticket_state.dart';

class BorrowTicketActionBloc
    extends Bloc<BorrowTicketEvent, BorrowTicketState> {
  final CancelBorrowTicketUseCase cancelBorrowTicketUseCase;
  final RenewBorrowTicketUseCase renewBorrowTicketUseCase;
  BorrowTicketActionBloc(
    this.cancelBorrowTicketUseCase,
    this.renewBorrowTicketUseCase,
  ) : super(BorrowTicketInitial()) {
    on<CancelBorrowTicketEvent>(_onCancelBorrowTicket);
    on<RenewBorrowTicketEvent>(_onRenewBorrowTicket);
  }

  Future<void> _onCancelBorrowTicket(
    CancelBorrowTicketEvent event,
    Emitter<BorrowTicketState> emit,
  ) async {
    try {
      await cancelBorrowTicketUseCase(event.ticketId);
      emit(BorrowTicketActionSuccess());
      DataRefreshService().triggerBookListRefresh();
      DataRefreshService().triggerHomeRefresh();
      DataRefreshService().triggerBorrowTicketListRefresh();
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(BorrowTicketActionFailure(error, e));
    } catch (e) {
      emit(BorrowTicketActionFailure('Lỗi khi hủy phiếu mượn', e));
    }
  }

  Future<void> _onRenewBorrowTicket(
    RenewBorrowTicketEvent event,
    Emitter<BorrowTicketState> emit,
  ) async {
    try {
      await renewBorrowTicketUseCase(event.ticketId);
      emit(BorrowTicketActionSuccess());
      DataRefreshService().triggerBorrowTicketListRefresh();
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(BorrowTicketActionFailure(error, e));
    } catch (e) {
      emit(BorrowTicketActionFailure('Lỗi khi gia hạn phiếu mượn', e));
    }
  }
}

class BorrowTicketListBloc extends Bloc<BorrowTicketEvent, BorrowTicketState> {
  final GetBorrowTicketsUseCase getBorrowTicketsUseCase;
  StreamSubscription<void>? _refreshSubscription;

  // Store current filter params
  String? _currentStatus;
  static const int _pageLimit = 10;

  BorrowTicketListBloc(this.getBorrowTicketsUseCase)
    : super(BorrowTicketInitial()) {
    on<LoadBorrowTicketsEvent>(_onLoadBorrowTickets);
    on<LoadMoreBorrowTicketsEvent>(_onLoadMoreBorrowTickets);
    on<RefreshBorrowTicketsEvent>(_onRefreshBorrowTickets);
    on<ChangeTicketStatusFilterEvent>(_onChangeStatusFilter);

    // Subscribe to borrow ticket list refresh events
    _refreshSubscription = DataRefreshService().onBorrowTicketListRefresh
        .listen((_) {
          add(RefreshBorrowTicketsEvent());
        });
  }

  Future<void> _onLoadBorrowTickets(
    LoadBorrowTicketsEvent event,
    Emitter<BorrowTicketState> emit,
  ) async {
    emit(BorrowTicketListLoading());
    _currentStatus = event.status;
    try {
      final (tickets, pagination) = await getBorrowTicketsUseCase(
        page: event.page,
        limit: event.limit,
        status: event.status,
      );
      final hasReachedMax = pagination.currentPage >= pagination.totalPages;
      emit(
        BorrowTicketListLoaded(
          tickets,
          pagination,
          currentStatus: _currentStatus,
          hasReachedMax: hasReachedMax,
        ),
      );
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(BorrowTicketListFailure(error, e));
    } catch (e) {
      emit(BorrowTicketListFailure('Lỗi khi load lịch sử mượn sách', e));
    }
  }

  Future<void> _onLoadMoreBorrowTickets(
    LoadMoreBorrowTicketsEvent event,
    Emitter<BorrowTicketState> emit,
  ) async {
    final currentState = state;
    if (currentState is! BorrowTicketListLoaded) return;
    if (currentState.isLoadingMore || currentState.hasReachedMax) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.pagination.currentPage + 1;
      final (newTickets, pagination) = await getBorrowTicketsUseCase(
        page: nextPage,
        limit: _pageLimit,
        status: _currentStatus,
      );

      final hasReachedMax = pagination.currentPage >= pagination.totalPages;
      final allTickets = [...currentState.tickets, ...newTickets];

      emit(
        BorrowTicketListLoaded(
          allTickets,
          pagination,
          currentStatus: _currentStatus,
          hasReachedMax: hasReachedMax,
        ),
      );
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(currentState.copyWith(isLoadingMore: false));
      // Optionally show error
      emit(BorrowTicketListFailure(error, e));
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onRefreshBorrowTickets(
    RefreshBorrowTicketsEvent event,
    Emitter<BorrowTicketState> emit,
  ) async {
    // Don't show loading when refreshing, silently update data
    try {
      final (tickets, pagination) = await getBorrowTicketsUseCase(
        page: 1,
        limit: _pageLimit,
        status: _currentStatus,
      );
      final hasReachedMax = pagination.currentPage >= pagination.totalPages;
      emit(
        BorrowTicketListLoaded(
          tickets,
          pagination,
          currentStatus: _currentStatus,
          hasReachedMax: hasReachedMax,
        ),
      );
    } on DioException catch (e) {
      // Keep current state if refresh fails
      print(
        'Error refreshing borrow tickets: ${ErrorHandler.getErrorMessage(e)}',
      );
    } catch (e) {
      print('Error refreshing borrow tickets: $e');
    }
  }

  Future<void> _onChangeStatusFilter(
    ChangeTicketStatusFilterEvent event,
    Emitter<BorrowTicketState> emit,
  ) async {
    _currentStatus = event.status;
    emit(BorrowTicketListLoading());
    try {
      final (tickets, pagination) = await getBorrowTicketsUseCase(
        page: 1,
        limit: _pageLimit,
        status: event.status,
      );
      final hasReachedMax = pagination.currentPage >= pagination.totalPages;
      emit(
        BorrowTicketListLoaded(
          tickets,
          pagination,
          currentStatus: _currentStatus,
          hasReachedMax: hasReachedMax,
        ),
      );
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(BorrowTicketListFailure(error, e));
    } catch (e) {
      emit(BorrowTicketListFailure('Lỗi khi load lịch sử mượn sách', e));
    }
  }

  @override
  Future<void> close() {
    _refreshSubscription?.cancel();
    return super.close();
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
