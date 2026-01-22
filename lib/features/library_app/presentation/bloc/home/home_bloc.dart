import 'package:flutter_bloc/flutter_bloc.dart';
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

  HomeBloc(
    this.getAllBooksUseCase,
    this.getPopularCategoriesUseCase,
    this.getRecommendedBooksUseCase,
  ) : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<RefreshHomeDataEvent>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      // Gọi song song 4 request:
      // 1. Sách mới nhất (sort='newest', limit=4)
      // 2. Sách phổ biến (sort='popular', limit=10)
      // 3. Thể loại phổ biến
      // 4. Sách được đề xuất

      final results = await Future.wait([
        getAllBooksUseCase(page: 1, limit: 4, sort: 'newest'),
        getAllBooksUseCase(page: 1, limit: 10, sort: 'popular'),
        getPopularCategoriesUseCase(),
        getRecommendedBooksUseCase(),
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
    // Gọi lại logic load data
    add(const LoadHomeDataEvent());
  }
}
