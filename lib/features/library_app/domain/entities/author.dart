import 'package:equatable/equatable.dart';

/// Author entity
/// Corresponds to `authors` table in database
class Author extends Equatable {
  final int authorId;
  final String name;
  final String? bio;
  final DateTime createdAt;

  const Author({
    required this.authorId,
    required this.name,
    this.bio,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [authorId, name, bio, createdAt];
}
