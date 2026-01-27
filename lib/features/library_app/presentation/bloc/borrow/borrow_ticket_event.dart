part of 'borrow_ticket_bloc.dart';

abstract class BorrowTicketEvent extends Equatable {
  const BorrowTicketEvent();

  @override
  List<Object?> get props => [];
}

class LoadBorrowTicketsEvent extends BorrowTicketEvent {
  final int page;
  final int limit;
  final String? status;

  const LoadBorrowTicketsEvent({this.page = 1, this.limit = 10, this.status});

  @override
  List<Object?> get props => [page, limit, status];
}

class LoadMoreBorrowTicketsEvent extends BorrowTicketEvent {
  const LoadMoreBorrowTicketsEvent();

  @override
  List<Object?> get props => [];
}

class RefreshBorrowTicketsEvent extends BorrowTicketEvent {
  const RefreshBorrowTicketsEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTicketStatusFilterEvent extends BorrowTicketEvent {
  final String? status;

  const ChangeTicketStatusFilterEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class LoadBorrowTicketDetailEvent extends BorrowTicketEvent {
  final int ticketId;

  const LoadBorrowTicketDetailEvent(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

class RefreshBorrowTicketDetailEvent extends BorrowTicketEvent {
  final int ticketId;

  const RefreshBorrowTicketDetailEvent(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

class CancelBorrowTicketEvent extends BorrowTicketEvent {
  final int ticketId;

  const CancelBorrowTicketEvent(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

class RenewBorrowTicketEvent extends BorrowTicketEvent {
  final int ticketId;

  const RenewBorrowTicketEvent(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}
