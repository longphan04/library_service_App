import '../entities/book_hold.dart';
import '../entities/borrow_ticket.dart';
import '../entities/pagination.dart';

abstract class BorrowRepository {
  Future<List<BookHold>> getBookHolds();
  Future<void> addBookHold(int bookId);
  Future<List<int>> removeBookHold(List<int> holdIds);
  Future<void> borrowNow(int bookId);
  Future<void> borrowFromHolds(List<int> holdIds);

  // history
  Future<(List<Ticket>, Pagination)> getBorrowTickets();
  Future<TicketDetail> getBorrowTicketDetail(int ticketId);
  Future<void> cancelBorrowTicket(int ticketId);
  Future<void> renewBorrowTicket(int ticketId);
}
