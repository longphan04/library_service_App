import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../bloc/book/book_bloc.dart';
import '../../bloc/borrow/borrow_bloc.dart';
import '../../widgets/my_button.dart';
import '../../widgets/search_app_bar.dart';
import '../../widgets/section_header.dart';
import 'list_books.dart';

class DetailPage extends StatefulWidget {
  final int bookId;
  final String initialCoverUrl;

  const DetailPage({
    super.key,
    required this.bookId,
    required this.initialCoverUrl,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookDetailBloc>().add(LoadBookDetailEvent(widget.bookId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navBackground,
      appBar: SearchAppBar(onSearchChanged: (query) {}, showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Book Image
            ClipRRect(
              child: CachedNetworkImage(
                imageUrl: widget.initialCoverUrl,
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
                            Row(
                              children: [
                                Text(
                                  'Còn ${state.bookDetail.availableCopies} cuốn',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  ' | 123 Cuốn đã mượn',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.subText,
                                  ),
                                ),
                              ],
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
                            Divider(thickness: 2, color: AppColors.background),
                            _buildDetailRow(
                              'Thể loại',
                              state.bookDetail.categories
                                      ?.map((category) => category.name)
                                      .toList() ??
                                  "",
                            ),
                            Divider(thickness: 2, color: AppColors.background),
                            _buildDetailRow(
                              'Tác giả',
                              state.bookDetail.authors
                                      ?.map((author) => author.name)
                                      .toList() ??
                                  "",
                            ),
                            Divider(thickness: 2, color: AppColors.background),
                            _buildDetailRow(
                              'Nhà xuất bản',
                              state.bookDetail.publisher?.name ?? "",
                            ),
                            Divider(thickness: 2, color: AppColors.background),
                            _buildDetailRow(
                              'Năm xuất bản',
                              state.bookDetail.publishYear?.toString() ?? "",
                            ),
                            Divider(thickness: 2, color: AppColors.background),
                            _buildDetailRow(
                              'Ngôn ngữ',
                              state.bookDetail.language ?? "",
                            ),
                            Divider(thickness: 2, color: AppColors.background),
                            _buildDetailRow(
                              'Kệ sách',
                              state.bookDetail.shelf?.code ?? "",
                            ),
                            Divider(thickness: 2, color: AppColors.background),
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
                            Text(
                              state.bookDetail.description ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.bodyText,
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Xem thêm',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue[400],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: AppColors.background,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            SectionHeader(
                              title: 'Khuyên dùng',
                              color: Colors.blue,
                            ),
                            const ListBooks(books: []),
                          ],
                        ),
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
      bottomNavigationBar: Container(
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: BlocConsumer<BorrowBloc, BorrowState>(
                builder: (context, state) {
                  return MyButton(
                    text: state is AddBookHoldLoading
                        ? 'Đang thêm...'
                        : 'Thêm vào kệ',
                    onPressed: state is AddBookHoldLoading
                        ? null
                        : () {
                            context.read<BorrowBloc>().add(
                              AddBookHoldEvent(widget.bookId),
                            );
                          },
                    isReversedColor: true,
                  );
                },
                listener: (BuildContext context, BorrowState state) {
                  if (state is AddBookHoldSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Đã thêm sách vào kệ thành công!'),
                        duration: const Duration(seconds: 1, milliseconds: 500),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 2,
                          left: 20,
                          right: 20,
                        ),
                      ),
                    );
                    context.read<BorrowBloc>().add(RefreshBookHoldsEvent());
                  } else if (state is AddBookHoldFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi: ${state.message}')),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MyButton(text: 'Mượn ngay', onPressed: () {}),
            ),
          ],
        ),
      ),
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
