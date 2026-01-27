import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/data_refresh_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../bloc/book/book_bloc.dart';
import '../../bloc/borrow/borrow_bloc.dart';
import '../../widgets/my_button.dart';
import '../../widgets/search_app_bar.dart';
import 'similar_books_section.dart';
import '../borrow/borrow_page.dart';

class DetailPage extends StatefulWidget {
  final int bookId;
  final bool? isUniqueId;
  final String? initialCoverUrl;

  const DetailPage({
    super.key,
    required this.bookId,
    this.isUniqueId,
    required this.initialCoverUrl,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    context.read<BookDetailBloc>().add(
      LoadBookDetailEvent(widget.bookId, isUniqueId: widget.isUniqueId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navBackground,
      appBar: const SearchAppBar(showBackButton: true),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<BookDetailBloc>().add(RefreshBookDetailEvent());
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Book Image
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: widget.initialCoverUrl ?? '',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) {
                    return Image(
                      image: imageProvider,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                  placeholder: (context, url) => Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: 300,
                    color: AppColors.hover,
                    child: Center(
                      child: Icon(
                        Icons.book,
                        color: AppColors.buttonPrimaryText,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              ),
              BlocBuilder<BookDetailBloc, BookState>(
                builder: (context, state) {
                  if (state is BookDetailLoading || state is BookInitial) {
                    return const SizedBox();
                  } else if (state is BookDetailFailure) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (state is BookDetailLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Book Info
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.bookDetail.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              Text(
                                state.bookDetail.availableCopies! > 0
                                    ? 'Còn sách'
                                    : 'Hết sách',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: state.bookDetail.availableCopies! > 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 10, color: AppColors.background),
                        // Details Section
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Chi tiết sách',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Divider(
                                thickness: 2,
                                color: AppColors.background,
                              ),
                              _buildDetailRow(
                                'Thể loại',
                                state.bookDetail.categories
                                        ?.map((category) => category.name)
                                        .toList() ??
                                    "",
                              ),
                              Divider(
                                thickness: 2,
                                color: AppColors.background,
                              ),
                              _buildDetailRow(
                                'Tác giả',
                                state.bookDetail.authors
                                        ?.map((author) => author.name)
                                        .toList() ??
                                    "",
                              ),
                              Divider(
                                thickness: 2,
                                color: AppColors.background,
                              ),
                              _buildDetailRow(
                                'Nhà xuất bản',
                                state.bookDetail.publisher?.name ?? "",
                              ),
                              Divider(
                                thickness: 2,
                                color: AppColors.background,
                              ),
                              _buildDetailRow(
                                'Năm xuất bản',
                                state.bookDetail.publishYear?.toString() ?? "",
                              ),
                              Divider(
                                thickness: 2,
                                color: AppColors.background,
                              ),
                              _buildDetailRow(
                                'Ngôn ngữ',
                                state.bookDetail.language ?? "",
                              ),
                              Divider(
                                thickness: 2,
                                color: AppColors.background,
                              ),
                              _buildDetailRow(
                                'Kệ sách',
                                state.bookDetail.shelf?.code ?? "",
                              ),
                              Divider(
                                thickness: 2,
                                color: AppColors.background,
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 10, color: AppColors.background),
                        // Description Section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mô tả sách',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.titleText,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildDescriptionSection(
                                state.bookDetail.description ?? "",
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                        SimilarBooksSection(
                          categoryId:
                              state.bookDetail.categories?.isNotEmpty == true
                              ? state.bookDetail.categories!.first.categoryId
                              : null,
                          categoryName:
                              state.bookDetail.categories?.isNotEmpty == true
                              ? state.bookDetail.categories!.first.name
                              : null,
                          excludeBookId: widget.bookId,
                        ),
                      ],
                    );
                  } else {
                    return Center(child: Text('Trạng thái không xác định'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: BlocBuilder<BookDetailBloc, BookState>(
                builder: (context, bookState) {
                  return BlocConsumer<BorrowBloc, BorrowState>(
                    builder: (context, state) {
                      return MyButton(
                        text: state is AddBookHoldLoading
                            ? 'Đang thêm...'
                            : 'Thêm vào kệ',
                        onPressed:
                            bookState is BookDetailLoaded &&
                                bookState.bookDetail.availableCopies! > 0
                            ? state is AddBookHoldLoading
                                  ? null
                                  : () {
                                      context.read<BorrowBloc>().add(
                                        AddBookHoldEvent(widget.bookId),
                                      );
                                    }
                            : null,
                        isReversedColor: true,
                      );
                    },
                    listener: (BuildContext context, BorrowState state) {
                      if (state is AddBookHoldSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Đã thêm sách vào kệ thành công!',
                            ),
                            duration: const Duration(
                              seconds: 1,
                              milliseconds: 500,
                            ),
                          ),
                        );
                        context.read<BorrowBloc>().add(RefreshBookHoldsEvent());
                        // Refresh book detail to update available copies
                        context.read<BookDetailBloc>().add(
                          RefreshBookDetailEvent(),
                        );
                        // Trigger refresh for all book lists and home
                        DataRefreshService().triggerBookListRefresh();
                        DataRefreshService().triggerHomeRefresh();
                        DataRefreshService().triggerBookHoldRefresh();
                        // Trigger refresh for all book lists and home
                        DataRefreshService().triggerBookListRefresh();
                        DataRefreshService().triggerHomeRefresh();
                        DataRefreshService().triggerBookHoldRefresh();
                      } else if (state is AddBookHoldFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            duration: const Duration(
                              seconds: 1,
                              milliseconds: 500,
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BlocBuilder<BookDetailBloc, BookState>(
                builder: (context, state) {
                  return MyButton(
                    text: 'Mượn ngay',
                    onPressed:
                        state is BookDetailLoaded &&
                            state.bookDetail.availableCopies! > 0
                        ? () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BorrowPage(book: state.bookDetail),
                              ),
                            );

                            // Refresh book detail after returning from borrow page
                            if (result == true || mounted) {
                              // ignore: use_build_context_synchronously
                              context.read<BookDetailBloc>().add(
                                RefreshBookDetailEvent(),
                              );
                            }
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(String description) {
    if (description.isEmpty) {
      return Text(
        'Không có mô tả',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.subText,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Tạo TextPainter để đếm số dòng
        final textSpan = TextSpan(
          text: description,
          style: TextStyle(fontSize: 14, color: AppColors.bodyText),
        );

        final textPainter = TextPainter(
          text: textSpan,
          textAlign: TextAlign.justify,
          textDirection: TextDirection.ltr,
          maxLines: null,
        );

        textPainter.layout(maxWidth: constraints.maxWidth);

        // Tính số dòng
        final numberOfLines = textPainter.computeLineMetrics().length;
        final needsToggle = numberOfLines > 5;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: AppColors.bodyText),
                  maxLines: _isDescriptionExpanded ? null : 5,
                  overflow: _isDescriptionExpanded
                      ? TextOverflow.visible
                      : TextOverflow.clip,
                  textAlign: TextAlign.justify,
                ),
                if (!_isDescriptionExpanded && needsToggle)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.5),
                              Colors.white,
                              Colors.white,
                            ],
                            stops: const [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (needsToggle) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isDescriptionExpanded = !_isDescriptionExpanded;
                  });
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    _isDescriptionExpanded ? 'Ẩn bớt' : 'Xem thêm',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    if (value is List<String>) {
      value = value.join(', ');
    }

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.bodyText),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: AppColors.bodyText),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
