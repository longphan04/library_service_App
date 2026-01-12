import 'package:equatable/equatable.dart';

/// Borrow item entity (detail of borrow ticket)
/// Corresponds to `borrow_items` table in database
class BorrowItem extends Equatable {
  final int borrowItemId;
  final int ticketId;
  final int copyId;
  final int bookId;
  final DateTime? returnedAt;
  final int? returnedBy;
  final BorrowItemStatus status;

  const BorrowItem({
    required this.borrowItemId,
    required this.ticketId,
    required this.copyId,
    required this.bookId,
    this.returnedAt,
    this.returnedBy,
    required this.status,
  });

  bool get isBorrowed => status == BorrowItemStatus.borrowed;
  bool get isReturned => status == BorrowItemStatus.returned;

  @override
  List<Object?> get props => [
    borrowItemId,
    ticketId,
    copyId,
    bookId,
    returnedAt,
    returnedBy,
    status,
  ];
}

/// Borrow item status
enum BorrowItemStatus {
  borrowed,
  returned,
  removed;

  String get value {
    switch (this) {
      case BorrowItemStatus.borrowed:
        return 'BORROWED';
      case BorrowItemStatus.returned:
        return 'RETURNED';
      case BorrowItemStatus.removed:
        return 'REMOVED';
    }
  }

  static BorrowItemStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'BORROWED':
        return BorrowItemStatus.borrowed;
      case 'RETURNED':
        return BorrowItemStatus.returned;
      case 'REMOVED':
        return BorrowItemStatus.removed;
      default:
        throw ArgumentError('Invalid BorrowItemStatus: $value');
    }
  }
}
