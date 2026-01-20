import 'package:equatable/equatable.dart';

enum TicketStatus { pending, approved, pickedUp, returned, overdue, cancelled }

class Ticket extends Equatable {
  final int id;
  final String code;
  final TicketStatus status;
  final DateTime requestedAt;
  final DateTime? approvedAt;
  final DateTime? pickupExpiresAt;
  final DateTime? pickedUpAt;
  final DateTime? dueDate;
  final int renewCount;
  final bool isOverdue;
  final int overdueDays;

  const Ticket({
    required this.id,
    required this.code,
    required this.status,
    required this.requestedAt,
    this.approvedAt,
    this.pickupExpiresAt,
    this.pickedUpAt,
    this.dueDate,
    required this.renewCount,
    required this.isOverdue,
    required this.overdueDays,
  });

  @override
  List<Object?> get props => [
    id,
    code,
    status,
    requestedAt,
    approvedAt,
    pickupExpiresAt,
    pickedUpAt,
    dueDate,
    renewCount,
    isOverdue,
    overdueDays,
  ];
}

class TicketDetail extends Equatable {
  final int id;
  final String code;
  final TicketStatus status;
  final DateTime requestedAt;
  final DateTime? approvedAt;
  final DateTime? pickupExpiresAt;
  final DateTime? pickedUpAt;
  final DateTime? dueDate;
  final int renewCount;
  final List<TicketItem> items;

  const TicketDetail({
    required this.id,
    required this.code,
    required this.status,
    required this.requestedAt,
    this.approvedAt,
    this.pickupExpiresAt,
    this.pickedUpAt,
    this.dueDate,
    required this.renewCount,
    required this.items,
  });

  @override
  List<Object?> get props => [
    id,
    code,
    status,
    requestedAt,
    approvedAt,
    pickupExpiresAt,
    pickedUpAt,
    dueDate,
    renewCount,
    items,
  ];
}

class TicketItem extends Equatable {
  final String status;
  final TicketCopy copy;
  final TicketBook book;

  const TicketItem({
    required this.status,
    required this.copy,
    required this.book,
  });

  @override
  List<Object?> get props => [status, copy, book];
}

class TicketCopy extends Equatable {
  final int id;
  final String note;

  const TicketCopy({required this.id, required this.note});

  @override
  List<Object?> get props => [id, note];
}

class TicketBook extends Equatable {
  final int bookId;
  final String title;
  final String? coverUrl;

  const TicketBook({required this.bookId, required this.title, this.coverUrl});

  @override
  List<Object?> get props => [bookId, title, coverUrl];
}
