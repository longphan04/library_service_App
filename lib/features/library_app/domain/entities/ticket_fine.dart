import 'package:equatable/equatable.dart';

/// Ticket fine entity for overdue books with ZaloPay payment tracking
/// Corresponds to `ticket_fines` table in database
class TicketFine extends Equatable {
  final int fineId;
  final int ticketId;
  final int memberId;
  final int ratePerDay;
  final int daysOverdue;
  final int unreturnedCount;
  final int amount;
  final FineStatus status;
  final String? appTransId;
  final String? zpTransId;
  final DateTime? paidAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TicketFine({
    required this.fineId,
    required this.ticketId,
    required this.memberId,
    required this.ratePerDay,
    required this.daysOverdue,
    required this.unreturnedCount,
    required this.amount,
    required this.status,
    this.appTransId,
    this.zpTransId,
    this.paidAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPaid => status == FineStatus.paid;
  bool get isUnpaid => status == FineStatus.unpaid;
  bool get isPending => status == FineStatus.pending;

  @override
  List<Object?> get props => [
    fineId,
    ticketId,
    memberId,
    ratePerDay,
    daysOverdue,
    unreturnedCount,
    amount,
    status,
    appTransId,
    zpTransId,
    paidAt,
    createdAt,
    updatedAt,
  ];
}

/// Fine payment status
enum FineStatus {
  unpaid,
  pending,
  paid,
  failed;

  String get value {
    switch (this) {
      case FineStatus.unpaid:
        return 'UNPAID';
      case FineStatus.pending:
        return 'PENDING';
      case FineStatus.paid:
        return 'PAID';
      case FineStatus.failed:
        return 'FAILED';
    }
  }

  static FineStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'UNPAID':
        return FineStatus.unpaid;
      case 'PENDING':
        return FineStatus.pending;
      case 'PAID':
        return FineStatus.paid;
      case 'FAILED':
        return FineStatus.failed;
      default:
        throw ArgumentError('Invalid FineStatus: $value');
    }
  }
}
