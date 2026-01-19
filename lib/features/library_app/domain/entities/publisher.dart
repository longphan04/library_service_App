import 'package:equatable/equatable.dart';

class Publisher extends Equatable {
  final int publisherId;
  final String name;

  const Publisher({required this.publisherId, required this.name});

  @override
  List<Object?> get props => [publisherId, name];
}
