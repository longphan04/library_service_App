import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/data_refresh_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/entities/book_hold.dart';
import '../../bloc/borrow/borrow_bloc.dart';
import '../../widgets/my_button.dart';
import 'borrow_item.dart';

class BorrowPage extends StatefulWidget {
  final List<BookHold> selectedHolds;
  final Book? book;

  const BorrowPage({super.key, this.selectedHolds = const [], this.book});

  @override
  State<BorrowPage> createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  bool _isExpanded = false;
  final int _initialItemCount = 2;

  late List<BookHold> _currentHolds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initData();

    if (widget.book == null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _checkExpiration();
      });
    }
  }

  void _initData() {
    if (widget.book != null) {
      final dummyHold = BookHold(
        holdId: -1,
        book: widget.book!,
        copyNote: '',
        expiresAt: DateTime.now(),
        copyId: -1,
      );
      _currentHolds = [dummyHold];
    } else {
      _currentHolds = List.from(widget.selectedHolds);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkExpiration() {
    final nowUtc = DateTime.now().toUtc();
    final expiredHolds = _currentHolds.where((h) {
      return h.expiresAt.toUtc().isBefore(nowUtc);
    }).toList();

    if (expiredHolds.isNotEmpty) {
      setState(() {
        _currentHolds.removeWhere((h) => expiredHolds.contains(h));
      });

      if (_currentHolds.isEmpty && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phiếu mượn đã hết hạn xác nhận')),
        );
      }
    } else {
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = _currentHolds.length;
    final itemsToShow = _isExpanded || totalItems <= _initialItemCount
        ? totalItems
        : _initialItemCount;

    final isBorrowNow = widget.book != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.navBackground,
        centerTitle: true,
        title: const Text(
          'Phiếu mượn sách',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.titleText,
          ),
        ),
      ),
      body: _currentHolds.isEmpty
          ? const SizedBox()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      itemBuilder: (context, index) {
                        final hold = _currentHolds[index];
                        final book = hold.book;

                        return BorrowItem(
                          title: book.title,
                          imageUrl: book.coverUrl ?? "",
                          author:
                              book.authors != null && book.authors!.isNotEmpty
                              ? book.authors![0].name +
                                    (book.authors!.length > 1
                                        ? ' + ${book.authors!.length - 1}'
                                        : '')
                              : 'Không rõ',
                          category:
                              book.categories != null &&
                                  book.categories!.isNotEmpty
                              ? book.categories![0].name +
                                    (book.categories!.length > 1
                                        ? ' + ${book.categories!.length - 1}'
                                        : '')
                              : 'Không rõ',
                          note: isBorrowNow ? null : hold.copyNote,
                          expiresAt: isBorrowNow ? null : hold.expiresAt,
                          onDelete: isBorrowNow
                              ? null
                              : () {
                                  setState(() {
                                    _currentHolds.remove(hold);
                                  });
                                  if (_currentHolds.isEmpty && mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                        );
                      },
                      itemCount: itemsToShow,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),

                    if (totalItems > _initialItemCount) ...[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Text(
                              _isExpanded ? 'Ẩn bớt' : 'Xem thêm',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryButton,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    const Text(
                      'Thời hạn dự kiến',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleText,
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: AppColors.sectionBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: AppColors.icon,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Trả sách vào: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.bodyText,
                                ),
                              ),
                              Text(
                                formatDate(
                                  DateTime.now().add(const Duration(days: 10)),
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Bạn sẽ được mượn sách trong khoảng 10 ngày.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.subText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Phần tổng kết số lượng sách
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: AppColors.sectionBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Đang mượn ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.subText,
                            ),
                          ),
                          Text(
                            '${_currentHolds.length.toString().padLeft(2, '0')} cuốn',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.bodyText,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'Tổng cộng: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.bodyText,
                            ),
                          ),
                          Text(
                            _currentHolds.length.toString().padLeft(2, '0'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.bodyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: BlocConsumer<BorrowBloc, BorrowState>(
          listener: (context, state) async {
            if (state is BorrowFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  duration: Duration(seconds: 1, milliseconds: 500),
                ),
              );
            }
            if (state is BorrowSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mượn sách thành công'),
                  duration: Duration(seconds: 1),
                ),
              );

              context.read<BorrowBloc>().add(RefreshBookHoldsEvent());

              if (widget.book != null) {
                DataRefreshService().triggerBookDetailRefresh(
                  widget.book!.bookId,
                );
              }
              // Trigger refresh for book lists and home
              DataRefreshService().triggerBookListRefresh();
              DataRefreshService().triggerHomeRefresh();
              Navigator.of(context).pop(true);
            }
          },
          builder: (context, state) {
            return MyButton(
              text: state is BorrowLoading ? 'Đang xử lý...' : 'Xác nhận',
              onPressed: state is BorrowLoading
                  ? null
                  : () {
                      if (widget.book != null) {
                        context.read<BorrowBloc>().add(
                          BorrowNowEvent(widget.book!.bookId),
                        );
                      } else {
                        final holdIds = _currentHolds
                            .map((h) => h.holdId)
                            .toList();
                        context.read<BorrowBloc>().add(
                          BorrowFromHoldsEvent(holdIds),
                        );
                      }
                    },
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
