import 'package:equatable/equatable.dart';

/// Book copy entity (physical copy)
/// Corresponds to `book_copies` table in database
class BookCopy extends Equatable {
  final int copyId;
  final int bookId;
  final String barcode;
  final CopyStatus status;
  final DateTime? acquiredAt;
  final String? note;
  final DateTime createdAt;

  const BookCopy({
    required this.copyId,
    required this.bookId,
    required this.barcode,
    required this.status,
    this.acquiredAt,
    this.note,
    required this.createdAt,
  });

  bool get isAvailable => status == CopyStatus.available;
  bool get isBorrowed => status == CopyStatus.borrowed;
  bool get isHeld => status == CopyStatus.held;

  @override
  List<Object?> get props => [
    copyId,
    bookId,
    barcode,
    status,
    acquiredAt,
    note,
    createdAt,
  ];
}

/// Book copy status
enum CopyStatus {
  available,
  held,
  borrowed,
  removed;

  String get value {
    switch (this) {
      case CopyStatus.available:
        return 'AVAILABLE';
      case CopyStatus.held:
        return 'HELD';
      case CopyStatus.borrowed:
        return 'BORROWED';
      case CopyStatus.removed:
        return 'REMOVED';
    }
  }

  static CopyStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'AVAILABLE':
        return CopyStatus.available;
      case 'HELD':
        return CopyStatus.held;
      case 'BORROWED':
        return CopyStatus.borrowed;
      case 'REMOVED':
        return CopyStatus.removed;
      default:
        throw ArgumentError('Invalid CopyStatus: $value');
    }
  }
}
