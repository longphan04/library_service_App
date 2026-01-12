import 'package:equatable/equatable.dart';

/// Borrow ticket entity
/// Corresponds to `borrow_tickets` table in database
class BorrowTicket extends Equatable {
  final int ticketId;
  final String ticketCode;
  final int memberId;
  final TicketStatus status;
  final DateTime requestedAt;
  final DateTime? approvedAt;
  final int? approvedBy;
  final DateTime? pickupExpiresAt;
  final DateTime? pickedUpAt;
  final int? pickedUpBy;
  final DateTime? dueDate;
  final int renewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BorrowTicket({
    required this.ticketId,
    required this.ticketCode,
    required this.memberId,
    required this.status,
    required this.requestedAt,
    this.approvedAt,
    this.approvedBy,
    this.pickupExpiresAt,
    this.pickedUpAt,
    this.pickedUpBy,
    this.dueDate,
    required this.renewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get canRenew => renewCount < 1 && status == TicketStatus.pickedUp;
  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!) && status == TicketStatus.pickedUp;
  }

  @override
  List<Object?> get props => [
    ticketId,
    ticketCode,
    memberId,
    status,
    requestedAt,
    approvedAt,
    approvedBy,
    pickupExpiresAt,
    pickedUpAt,
    pickedUpBy,
    dueDate,
    renewCount,
    createdAt,
    updatedAt,
  ];
}

/// Borrow ticket status
enum TicketStatus {
  pending,
  approved,
  pickedUp,
  returned,
  cancelled;

  String get value {
    switch (this) {
      case TicketStatus.pending:
        return 'PENDING';
      case TicketStatus.approved:
        return 'APPROVED';
      case TicketStatus.pickedUp:
        return 'PICKED_UP';
      case TicketStatus.returned:
        return 'RETURNED';
      case TicketStatus.cancelled:
        return 'CANCELLED';
    }
  }

  static TicketStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return TicketStatus.pending;
      case 'APPROVED':
        return TicketStatus.approved;
      case 'PICKED_UP':
        return TicketStatus.pickedUp;
      case 'RETURNED':
        return TicketStatus.returned;
      case 'CANCELLED':
        return TicketStatus.cancelled;
      default:
        throw ArgumentError('Invalid TicketStatus: $value');
    }
  }
}
