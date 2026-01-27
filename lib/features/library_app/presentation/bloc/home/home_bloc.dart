import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/data_refresh_service.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/pagination.dart';
import '../../../domain/usecases/book_usecase.dart';
import '../../../domain/usecases/category_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAllBooksUseCase getAllBooksUseCase;
  final GetPopularCategoriesUseCase getPopularCategoriesUseCase;
  final GetRecommendedBooksUseCase getRecommendedBooksUseCase;
  StreamSubscription<void>? _refreshSubscription;

  HomeBloc(
    this.getAllBooksUseCase,
    this.getPopularCategoriesUseCase,
    this.getRecommendedBooksUseCase,
  ) : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<RefreshHomeDataEvent>(_onRefreshHomeData);

    // Subscribe to home refresh events
    _refreshSubscription = DataRefreshService().onHomeRefresh.listen((_) {
      add(const RefreshHomeDataEvent());
    });
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      // Gọi song song các request, xử lý lỗi riêng cho từng request
      // để một API fail không ảnh hưởng toàn bộ trang
      final results = await Future.wait([
        getAllBooksUseCase(page: 1, limit: 4, sort: 'newest').catchError((e) {
          print('Error loading newest books: $e');
          return (
            <Book>[],
            const Pagination(
              currentPage: 1,
              totalPages: 1,
              pageSize: 4,
              totalItems: 0,
            ),
          );
        }),
        getAllBooksUseCase(page: 1, limit: 10, sort: 'popular').catchError((e) {
          print('Error loading popular books: $e');
          return (
            <Book>[],
            const Pagination(
              currentPage: 1,
              totalPages: 1,
              pageSize: 10,
              totalItems: 0,
            ),
          );
        }),
        getPopularCategoriesUseCase().catchError((e) {
          print('Error loading popular categories: $e');
          return <Category>[];
        }),
        getRecommendedBooksUseCase().catchError((e) {
          print('Error loading recommended books: $e');
          return <Book>[];
        }),
      ]);

      final newestResult = results[0] as (List<Book>, Pagination);
      final popularResult = results[1] as (List<Book>, Pagination);
      final categoriesResult = results[2] as List<Category>;
      final recommendedBooks = results[3] as List<Book>;

      emit(
        HomeLoaded(
          newestBooks: newestResult.$1,
          popularBooks: popularResult.$1,
          popularCategories: categoriesResult,
          recommendedBooks: recommendedBooks,
        ),
      );
    } catch (e) {
      emit(HomeFailure('Lỗi khi tải dữ liệu trang chủ: $e'));
      print('Lỗi khi tải dữ liệu trang chủ: $e');
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Don't show loading when refreshing, keep current state
    try {
      final results = await Future.wait([
        getAllBooksUseCase(page: 1, limit: 4, sort: 'newest').catchError((e) {
          print('Error refreshing newest books: $e');
          return (
            <Book>[],
            const Pagination(
              currentPage: 1,
              totalPages: 1,
              pageSize: 4,
              totalItems: 0,
            ),
          );
        }),
        getAllBooksUseCase(page: 1, limit: 10, sort: 'popular').catchError((e) {
          print('Error refreshing popular books: $e');
          return (
            <Book>[],
            const Pagination(
              currentPage: 1,
              totalPages: 1,
              pageSize: 10,
              totalItems: 0,
            ),
          );
        }),
        getPopularCategoriesUseCase().catchError((e) {
          print('Error refreshing popular categories: $e');
          return <Category>[];
        }),
        getRecommendedBooksUseCase().catchError((e) {
          print('Error refreshing recommended books: $e');
          return <Book>[];
        }),
      ]);

      final newestResult = results[0] as (List<Book>, Pagination);
      final popularResult = results[1] as (List<Book>, Pagination);
      final categoriesResult = results[2] as List<Category>;
      final recommendedBooks = results[3] as List<Book>;

      emit(
        HomeLoaded(
          newestBooks: newestResult.$1,
          popularBooks: popularResult.$1,
          popularCategories: categoriesResult,
          recommendedBooks: recommendedBooks,
        ),
      );
    } catch (e) {
      // Keep current state if refresh fails, don't emit failure
      print('Error refreshing home data: $e');
    }
  }

  @override
  Future<void> close() {
    _refreshSubscription?.cancel();
    return super.close();
  }
}
