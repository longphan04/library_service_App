import 'package:equatable/equatable.dart';

class Pagination extends Equatable {
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalItems;

  const Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalItems,
  });

  @override
  List<Object> get props => [currentPage, totalPages, pageSize, totalItems];
}
