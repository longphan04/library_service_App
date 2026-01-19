import 'package:equatable/equatable.dart';

class Shelf extends Equatable {
  final int shelfId;
  final String code;

  const Shelf({required this.shelfId, required this.code});

  @override
  List<Object?> get props => [shelfId, code];
}
