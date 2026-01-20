import '../../domain/entities/book_hold.dart';
import '../../domain/entities/borrow_ticket.dart';
import '../../domain/entities/pagination.dart';
import '../../domain/repositories/borrow_repository.dart';
import '../datasources/remote/borrow_remote_datasource.dart';

class BorrowRepositoryImpl implements BorrowRepository {
  final BorrowRemoteDatasource remoteDatasource;

  BorrowRepositoryImpl({required this.remoteDatasource});

  @override
  Future<void> cancelBorrowTicket(int ticketId) async {
    try {
      await remoteDatasource.cancelBorrowTicket(ticketId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> renewBorrowTicket(int ticketId) async {
    try {
      await remoteDatasource.renewBorrowTicket(ticketId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BookHold>> getBookHolds() async {
    try {
      final models = await remoteDatasource.fetchBorrowBooks();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addBookHold(int bookId) async {
    try {
      await remoteDatasource.addBookHold(bookId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<int>> removeBookHold(List<int> holdIds) {
    try {
      return remoteDatasource.removeBookHold(holdIds);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> borrowFromHolds(List<int> holdIds) async {
    try {
      await remoteDatasource.borrowFromHolds(holdIds);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> borrowNow(int bookId) async {
    try {
      await remoteDatasource.borrowNow(bookId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(List<Ticket>, Pagination)> getBorrowTickets() async {
    try {
      final ticketListModel = await remoteDatasource.fetchBorrowTickets();
      final tickets = ticketListModel.data
          .map((model) => model.toEntity())
          .toList();
      final pagination = ticketListModel.pagination.toEntity();
      return (tickets, pagination);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TicketDetail> getBorrowTicketDetail(int ticketId) async {
    try {
      final ticketDetailModel = await remoteDatasource.fetchBorrowTicketDetail(
        ticketId,
      );
      return ticketDetailModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
