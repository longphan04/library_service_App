import 'package:equatable/equatable.dart';

/// Book hold entity (temporary cart before creating borrow ticket)
/// Corresponds to `book_holds` table in database
class BookHold extends Equatable {
  final int holdId;
  final int memberId;
  final int copyId;
  final DateTime expiresAt;
  final DateTime createdAt;

  const BookHold({
    required this.holdId,
    required this.memberId,
    required this.copyId,
    required this.expiresAt,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [holdId, memberId, copyId, expiresAt, createdAt];
}
