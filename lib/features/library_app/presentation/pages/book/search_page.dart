import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/book.dart';
import '../../bloc/book/book_bloc.dart';
import '../../widgets/search_app_bar.dart';
import 'list_books.dart';

/// Enum để xác định loại tìm kiếm/hiển thị
enum SearchType {
  query, // Tìm kiếm theo từ khóa
  category, // Lọc theo danh mục
  viewAll, // Xem tất cả (newest)
}

class SearchPage extends StatefulWidget {
  final String? query;
  final int? categoryId;
  final String? categoryName;
  final SearchType searchType;
  final String? customTitle;

  const SearchPage({
    super.key,
    this.query,
    this.categoryId,
    this.categoryName,
    this.searchType = SearchType.query,
    this.customTitle,
  });

  factory SearchPage.fromQuery(String query) {
    return SearchPage(query: query, searchType: SearchType.query);
  }

  factory SearchPage.fromCategory({
    required int categoryId,
    required String categoryName,
  }) {
    return SearchPage(
      categoryId: categoryId,
      categoryName: categoryName,
      searchType: SearchType.category,
    );
  }

  factory SearchPage.viewAll({String? title}) {
    return SearchPage(searchType: SearchType.viewAll, customTitle: title);
  }

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final BookBloc _bookBloc;
  late final ScrollController _scrollController;

  String _currentSort = 'newest';
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _bookBloc = BookBloc(getIt());
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load sách ban đầu
    _loadBooks();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _bookBloc.close();
    super.dispose();
  }

  void _loadBooks() {
    _bookBloc.add(
      LoadBooksEvent(
        page: 1,
        limit: 10,
        query: widget.searchType == SearchType.query ? widget.query : null,
        categoryId: widget.searchType == SearchType.category
            ? widget.categoryId.toString()
            : null,
        sort: _currentSort,
      ),
    );
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = 200.0;

    if (currentScroll >= maxScroll - threshold) {
      final state = _bookBloc.state;
      if (state is ListBooksLoaded) {
        if (state.pagination.currentPage < state.pagination.totalPages) {
          _isLoadingMore = true;
          _bookBloc.add(LoadMoreBooksEvent());
        }
      }
    }
  }

  void _onSortChanged(String? newSort) {
    if (newSort != null && newSort != _currentSort) {
      setState(() {
        _currentSort = newSort;
      });
      _loadBooks();
    }
  }

  String _buildHeaderTitle() {
    switch (widget.searchType) {
      case SearchType.query:
        return 'Kết quả của: ${widget.query ?? ""}';
      case SearchType.category:
        return widget.categoryName ?? 'Danh mục';
      case SearchType.viewAll:
        return widget.customTitle ?? 'Tất cả sách';
    }
  }

  TextStyle _buildHeaderStyle() {
    switch (widget.searchType) {
      case SearchType.query:
        return const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.titleText,
        );
      case SearchType.category:
        return const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.titleText,
        );
      case SearchType.viewAll:
        return const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.titleText,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bookBloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const SearchAppBar(showBackButton: true),
        body: BlocConsumer<BookBloc, BookState>(
          listener: (context, state) {
            if (state is ListBooksLoaded || state is ListBooksFailure) {
              _isLoadingMore = false;
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                _loadBooks();
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),
                  if (state is ListBooksLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state is ListBooksFailure)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: AppColors.subText,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: TextStyle(color: AppColors.subText),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadBooks,
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (state is ListBooksLoaded ||
                      state is ListBooksLoadingMore)
                    ..._buildBooksList(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              _buildHeaderTitle(),
              style: _buildHeaderStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.searchType != SearchType.viewAll) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.sectionBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _currentSort,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.icon,
                  ),
                  isDense: true,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.bodyText,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'newest', child: Text('Mới nhất')),
                    DropdownMenuItem(value: 'popular', child: Text('Phổ biến')),
                  ],
                  onChanged: _onSortChanged,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildBooksList(BookState state) {
    List<Book> books = [];
    bool isLoadingMore = false;
    bool hasMore = false;

    if (state is ListBooksLoaded) {
      books = state.books;
      hasMore = state.pagination.currentPage < state.pagination.totalPages;
    } else if (state is ListBooksLoadingMore) {
      books = state.previousState.books;
      isLoadingMore = true;
      hasMore = true;
    }

    if (books.isEmpty) {
      return [
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: AppColors.subText),
                const SizedBox(height: 16),
                Text(
                  'Không tìm thấy sách nào',
                  style: TextStyle(fontSize: 16, color: AppColors.subText),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return [
      SliverToBoxAdapter(child: ListBooks(books: books)),
      if (isLoadingMore || hasMore)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: isLoadingMore
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink(),
            ),
          ),
        ),
    ];
  }
}
