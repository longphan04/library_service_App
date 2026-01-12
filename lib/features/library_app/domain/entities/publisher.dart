import 'package:equatable/equatable.dart';

/// Publisher entity
/// Corresponds to `publishers` table in database
class Publisher extends Equatable {
  final int publisherId;
  final String name;
  final DateTime createdAt;

  const Publisher({
    required this.publisherId,
    required this.name,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [publisherId, name, createdAt];
}
