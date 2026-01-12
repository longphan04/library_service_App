import 'package:equatable/equatable.dart';

/// Shelf entity for physical book location
/// Corresponds to `shelves` table in database
class Shelf extends Equatable {
  final int shelfId;
  final String code;
  final String? name;
  final DateTime createdAt;

  const Shelf({
    required this.shelfId,
    required this.code,
    this.name,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [shelfId, code, name, createdAt];
}
