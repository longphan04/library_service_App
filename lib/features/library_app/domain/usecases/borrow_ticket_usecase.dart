import '../entities/borrow_ticket.dart';
import '../entities/pagination.dart';
import '../repositories/borrow_repository.dart';

class GetBorrowTicketsUseCase {
  final BorrowRepository repository;

  GetBorrowTicketsUseCase(this.repository);

  Future<(List<Ticket>, Pagination)> call({
    int page = 1,
    int limit = 10,
    String? status,
  }) {
    return repository.getBorrowTickets(
      page: page,
      limit: limit,
      status: status,
    );
  }
}

class GetBorrowTicketDetailUseCase {
  final BorrowRepository repository;

  GetBorrowTicketDetailUseCase(this.repository);

  Future<Ticket> call(int ticketId) {
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
