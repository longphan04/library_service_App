part of 'borrow_ticket_bloc.dart';

abstract class BorrowTicketState extends Equatable {
  const BorrowTicketState();

  @override
  List<Object> get props => [];
}

class BorrowTicketInitial extends BorrowTicketState {
  @override
  List<Object> get props => [];
}

class BorrowTicketListLoading extends BorrowTicketState {
  @override
  List<Object> get props => [];
}

class BorrowTicketListLoaded extends BorrowTicketState {
  final List<Ticket> tickets;
  final Pagination pagination;

  const BorrowTicketListLoaded(this.tickets, this.pagination);

  @override
  List<Object> get props => [tickets, pagination];
}

class BorrowTicketListFailure extends BorrowTicketState {
  final String message;
  final Object error;

  const BorrowTicketListFailure(this.message, this.error);

  @override
  List<Object> get props => [message, error];
}

class BorrowTicketDetailLoading extends BorrowTicketState {
  @override
  List<Object> get props => [];
}

class BorrowTicketDetailLoaded extends BorrowTicketState {
  final TicketDetail ticketDetail;

  const BorrowTicketDetailLoaded(this.ticketDetail);

  @override
  List<Object> get props => [ticketDetail];
}

class BorrowTicketDetailFailure extends BorrowTicketState {
  final String message;
  final Object error;

  const BorrowTicketDetailFailure(this.message, this.error);

  @override
  List<Object> get props => [message, error];
}

class BorrowTicketCanceling extends BorrowTicketState {
  @override
  List<Object> get props => [];
}

class BorrowTicketRenewing extends BorrowTicketState {
  @override
  List<Object> get props => [];
}

class BorrowTicketActionFailure extends BorrowTicketState {
  final String message;
  final Object error;

  const BorrowTicketActionFailure(this.message, this.error);

  @override
  List<Object> get props => [message, error];
}
