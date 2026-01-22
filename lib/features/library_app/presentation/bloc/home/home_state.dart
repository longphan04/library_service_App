import 'package:equatable/equatable.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/entities/category.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Book> newestBooks; // Top 4 sách mới
  final List<Book> popularBooks; // Top 10 sách phổ biến
  final List<Category> popularCategories; // Thể loại phổ biến
  final List<Book> recommendedBooks; // Sách được đề xuất

  const HomeLoaded({
    required this.newestBooks,
    required this.popularBooks,
    required this.popularCategories,
    required this.recommendedBooks,
  });

  @override
  List<Object?> get props => [
    newestBooks,
    popularBooks,
    popularCategories,
    recommendedBooks,
  ];
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure(this.message);

  @override
  List<Object?> get props => [message];
}
