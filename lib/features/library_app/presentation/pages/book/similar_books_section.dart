import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/book.dart';
import '../../bloc/book/book_bloc.dart';
import 'list_books.dart';
import '../../widgets/section_header.dart';

class SimilarBooksSection extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;
  final int excludeBookId;

  const SimilarBooksSection({
    super.key,
    required this.categoryId,
    this.categoryName,
    required this.excludeBookId,
  });

  @override
  State<SimilarBooksSection> createState() => _SimilarBooksSectionState();
}

class _SimilarBooksSectionState extends State<SimilarBooksSection> {
  late final BookBloc _bookBloc;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _bookBloc = BookBloc(getIt());
    _loadBooks();
  }

  @override
  void dispose() {
    _bookBloc.close();
    super.dispose();
  }

  void _loadBooks() {
    if (widget.categoryId == null) return;
    _bookBloc.add(
      LoadBooksEvent(
        page: 1,
        limit: 10,
        categoryId: widget.categoryId.toString(),
        sort: 'newest',
      ),
    );
  }

  void _loadMore() {
    if (_isLoadingMore) return;
    final state = _bookBloc.state;
    if (state is ListBooksLoaded) {
      if (state.pagination.currentPage < state.pagination.totalPages) {
        _isLoadingMore = true;
        _bookBloc.add(LoadMoreBooksEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryId == null) {
      return const SizedBox.shrink();
    }

    return BlocProvider.value(
      value: _bookBloc,
      child: Container(
        color: AppColors.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SectionHeader(title: 'Sách tương tự', color: Colors.blue),
            BlocConsumer<BookBloc, BookState>(
              listener: (context, state) {
                if (state is ListBooksLoaded || state is ListBooksFailure) {
                  _isLoadingMore = false;
                }
              },
              builder: (context, state) {
                if (state is ListBooksLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is ListBooksFailure) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            state.message,
                            style: TextStyle(color: AppColors.subText),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _loadBooks,
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                List<Book> books = [];
                bool isLoadingMore = false;
                bool hasMore = false;

                if (state is ListBooksLoaded) {
                  books = state.books
                      .where((book) => book.bookId != widget.excludeBookId)
                      .toList();
                  hasMore =
                      state.pagination.currentPage <
                      state.pagination.totalPages;
                } else if (state is ListBooksLoadingMore) {
                  books = state.previousState.books
                      .where((book) => book.bookId != widget.excludeBookId)
                      .toList();
                  isLoadingMore = true;
                  hasMore = true;
                }

                if (books.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'Không có sách tương tự',
                        style: TextStyle(color: AppColors.subText),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    ListBooks(books: books),
                    if (hasMore)
                      _LoadMoreTrigger(
                        onLoadMore: _loadMore,
                        isLoading: isLoadingMore,
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadMoreTrigger extends StatefulWidget {
  final VoidCallback onLoadMore;
  final bool isLoading;

  const _LoadMoreTrigger({required this.onLoadMore, required this.isLoading});

  @override
  State<_LoadMoreTrigger> createState() => _LoadMoreTriggerState();
}

class _LoadMoreTriggerState extends State<_LoadMoreTrigger> {
  bool _hasTriggered = false;

  @override
  void didUpdateWidget(_LoadMoreTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset flag khi loading xong
    if (oldWidget.isLoading && !widget.isLoading) {
      _hasTriggered = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trigger load more khi widget này được build lần đầu (visible)
    if (!_hasTriggered && !widget.isLoading) {
      _hasTriggered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onLoadMore();
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: widget.isLoading
            ? const CircularProgressIndicator()
            : const SizedBox(height: 40),
      ),
    );
  }
}
