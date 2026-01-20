part of 'borrow_ticket_bloc.dart';

abstract class BorrowTicketEvent extends Equatable {
  const BorrowTicketEvent();

  @override
  List<Object> get props => [];
}

class LoadBorrowTicketsEvent extends BorrowTicketEvent {
  @override
  List<Object> get props => [];
}

class RefreshBorrowTicketsEvent extends BorrowTicketEvent {
  @override
  List<Object> get props => [];
}

class LoadBorrowTicketDetailEvent extends BorrowTicketEvent {
  final int ticketId;

  const LoadBorrowTicketDetailEvent(this.ticketId);

  @override
  List<Object> get props => [ticketId];
}

class RefreshBorrowTicketDetailEvent extends BorrowTicketEvent {
  final int ticketId;

  const RefreshBorrowTicketDetailEvent(this.ticketId);

  @override
  List<Object> get props => [ticketId];
}

class CancelBorrowTicketEvent extends BorrowTicketEvent {
  final int ticketId;

  const CancelBorrowTicketEvent(this.ticketId);

  @override
  List<Object> get props => [ticketId];
}

class RenewBorrowTicketEvent extends BorrowTicketEvent {
  final int ticketId;

  const RenewBorrowTicketEvent(this.ticketId);

  @override
  List<Object> get props => [ticketId];
}
