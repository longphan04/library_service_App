import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/error_handler.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/usecases/category_usecase.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoryBloc({required this.getCategoriesUseCase})
    : super(CategoryInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<RefreshCategoriesEvent>(_onRefreshCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final categories = await getCategoriesUseCase();
      emit(CategoryLoaded(categories));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(CategoryFailure(error, e));
    } catch (e) {
      emit(CategoryFailure('Lỗi khi load danh mục', e));
    }
  }

  Future<void> _onRefreshCategories(
    RefreshCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      final categories = await getCategoriesUseCase();
      for (var element in categories) {
        print(element.image);
      }
      emit(CategoryLoaded(categories));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(CategoryFailure(error, e));
    } catch (e) {
      emit(CategoryFailure('Lỗi khi làm mới danh mục', e));
    }
  }
}
