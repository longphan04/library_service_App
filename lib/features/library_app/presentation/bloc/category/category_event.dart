part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends CategoryEvent {
  @override
  List<Object?> get props => [];
}

class RefreshCategoriesEvent extends CategoryEvent {
  @override
  List<Object?> get props => [];
}
