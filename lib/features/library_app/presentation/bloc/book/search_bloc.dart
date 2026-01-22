import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../core/utils/error_handler.dart';
import '../../../domain/usecases/book_usecase.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchLoading extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchSuggestionsLoaded extends SearchState {
  final List<String> suggestions;
  const SearchSuggestionsLoaded(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}

class SearchFailure extends SearchState {
  final String message;
  const SearchFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchBooksUseCase _getSuggestionsUseCase;

  SearchBloc(this._getSuggestionsUseCase) : super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 300))
          .switchMap(mapper),
    );
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      final suggestions = await _getSuggestionsUseCase(event.query);
      emit(SearchSuggestionsLoaded(suggestions));
    } on DioException catch (e) {
      final error = ErrorHandler.getErrorMessage(e);
      emit(SearchFailure('Lỗi khi tải gợi ý tìm kiếm: $error'));
    } catch (e) {
      emit(SearchFailure('Lỗi khi tải gợi ý tìm kiếm: $e'));
    }
  }
}
