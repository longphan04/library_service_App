import 'package:equatable/equatable.dart';
import 'book.dart';

class BookHold extends Equatable {
  final int holdId;
  final DateTime expiresAt;
  final int copyId;
  final String copyNote;
  final Book book;

  final bool isSelected;

  const BookHold({
    required this.holdId,
    required this.expiresAt,
    required this.copyId,
    required this.copyNote,
    required this.book,
    this.isSelected = false,
  });

  BookHold copyWith({
    int? holdId,
    DateTime? expiresAt,
    int? copyId,
    String? copyNote,
    Book? book,
    bool? isSelected,
  }) {
    return BookHold(
      holdId: holdId ?? this.holdId,
      expiresAt: expiresAt ?? this.expiresAt,
      copyId: copyId ?? this.copyId,
      copyNote: copyNote ?? this.copyNote,
      book: book ?? this.book,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [
    holdId,
    expiresAt,
    copyId,
    copyNote,
    book,
    isSelected,
  ];
}
