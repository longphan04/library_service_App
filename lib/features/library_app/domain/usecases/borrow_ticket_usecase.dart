import '../entities/borrow_ticket.dart';
import '../entities/pagination.dart';
import '../repositories/borrow_repository.dart';

class GetBorrowTicketsUseCase {
  final BorrowRepository repository;

  GetBorrowTicketsUseCase(this.repository);

  Future<(List<Ticket>, Pagination)> call() {
    return repository.getBorrowTickets();
  }
}

class GetBorrowTicketDetailUseCase {
  final BorrowRepository repository;

  GetBorrowTicketDetailUseCase(this.repository);

  Future<TicketDetail> call(int ticketId) {
    return repository.getBorrowTicketDetail(ticketId);
  }
}

class CancelBorrowTicketUseCase {
  final BorrowRepository repository;

  CancelBorrowTicketUseCase(this.repository);

  Future<void> call(int ticketId) {
    return repository.cancelBorrowTicket(ticketId);
  }
}

class RenewBorrowTicketUseCase {
  final BorrowRepository repository;

  RenewBorrowTicketUseCase(this.repository);

  Future<void> call(int ticketId) {
    return repository.renewBorrowTicket(ticketId);
  }
}
