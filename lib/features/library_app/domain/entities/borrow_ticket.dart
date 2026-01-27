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
  final DateTime? returnedAt;
  final DateTime? cancelledAt;
  final int renewCount;

  final bool isOverdue;
  final int overdueDays;
  final List<TicketItem>? items;

  const Ticket({
    required this.id,
    required this.code,
    required this.status,
    required this.requestedAt,
    this.approvedAt,
    this.pickupExpiresAt,
    this.pickedUpAt,
    this.dueDate,
    this.returnedAt,
    this.cancelledAt,
    required this.renewCount,
    this.isOverdue = false,
    this.overdueDays = 0,
    this.items,
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
    returnedAt,
    cancelledAt,
    renewCount,
    isOverdue,
    overdueDays,
    items,
  ];

  Ticket copyWith({
    int? id,
    String? code,
    TicketStatus? status,
    DateTime? requestedAt,
    DateTime? approvedAt,
    DateTime? pickupExpiresAt,
    DateTime? pickedUpAt,
    DateTime? dueDate,
    DateTime? returnedAt,
    DateTime? cancelledAt,
    int? renewCount,
    bool? isOverdue,
    int? overdueDays,
    List<TicketItem>? items,
  }) {
    return Ticket(
      id: id ?? this.id,
      code: code ?? this.code,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      pickupExpiresAt: pickupExpiresAt ?? this.pickupExpiresAt,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
      dueDate: dueDate ?? this.dueDate,
      returnedAt: returnedAt ?? this.returnedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      renewCount: renewCount ?? this.renewCount,
      isOverdue: isOverdue ?? this.isOverdue,
      overdueDays: overdueDays ?? this.overdueDays,
      items: items ?? this.items,
    );
  }
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
