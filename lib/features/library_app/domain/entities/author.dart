import 'package:equatable/equatable.dart';

class Author extends Equatable {
  final int authorId;
  final String name;

  const Author({required this.authorId, required this.name});

  @override
  List<Object?> get props => [authorId, name];
}
