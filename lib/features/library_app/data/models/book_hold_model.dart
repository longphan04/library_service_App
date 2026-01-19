import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/book_hold.dart';
import 'book_model.dart';

part 'book_hold_model.g.dart';

@JsonSerializable()
class BookHoldModel {
  @JsonKey(name: 'hold_id')
  final int holdId;

  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;

  @JsonKey(name: 'copy')
  final HoldCopyModel copy;

  @JsonKey(name: 'book')
  final BookModel book;

  const BookHoldModel({
    required this.holdId,
    required this.expiresAt,
    required this.copy,
    required this.book,
  });

  factory BookHoldModel.fromJson(Map<String, dynamic> json) =>
      _$BookHoldModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookHoldModelToJson(this);

  BookHold toEntity() {
    return BookHold(
      holdId: holdId,
      expiresAt: expiresAt,
      copyId: copy.copyId,
      copyNote: copy.note,
      book: book.toEntity(),
      isSelected: false,
    );
  }
}

@JsonSerializable()
class HoldCopyModel {
  @JsonKey(name: 'copy_id')
  final int copyId;

  @JsonKey(name: 'note')
  final String note;

  const HoldCopyModel({required this.copyId, required this.note});

  factory HoldCopyModel.fromJson(Map<String, dynamic> json) =>
      _$HoldCopyModelFromJson(json);

  Map<String, dynamic> toJson() => _$HoldCopyModelToJson(this);
}
