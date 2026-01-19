import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/book_hold.dart';
import '../../widgets/my_button.dart';
import 'borrow_item.dart';

class BorrowPage extends StatefulWidget {
  final List<BookHold> selectedHolds;

  const BorrowPage({super.key, required this.selectedHolds});

  @override
  State<BorrowPage> createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  bool _isExpanded = false;
  final int _initialItemCount = 2;

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.selectedHolds.length;
    final itemsToShow = _isExpanded
        ? totalItems
        : (totalItems < _initialItemCount ? totalItems : _initialItemCount);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.navBackground,
        centerTitle: true,
        title: const Text(
          'Mượn sách',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.titleText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                itemBuilder: (context, index) {
                  final hold = widget.selectedHolds[index];
                  final book = hold.book;
                  return BorrowItem(
                    title: book.title,
                    author: book.authors != null && book.authors!.isNotEmpty
                        ? book.authors![0].name +
                              (book.authors!.length > 1
                                  ? ' + ${book.authors!.length - 1}'
                                  : '')
                        : 'Không rõ',
                    category:
                        book.categories != null && book.categories!.isNotEmpty
                        ? book.categories![0].name +
                              (book.categories!.length > 1
                                  ? ' + ${book.categories!.length - 1}'
                                  : '')
                        : 'Không rõ',
                    availableCount: book.availableCopies ?? 0,
                  );
                },
                itemCount: itemsToShow,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
              if (totalItems > _initialItemCount && !_isExpanded)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = true;
                        });
                      },
                      child: Text(
                        'Xem thêm',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryButton,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              if (totalItems > _initialItemCount && _isExpanded)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = false;
                        });
                      },
                      child: Text(
                        'Ẩn bớt',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryButton,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              Text(
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
                        Icon(Icons.access_time, color: AppColors.icon),
                        const SizedBox(width: 10),
                        const Text(
                          'Trả sách vào',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.bodyText,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.calendar_month_outlined,
                          color: AppColors.icon,
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryButton,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Tháng một 16, 2026',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'Bạn sẽ được mượn sách trong khoảng 14 ngày.',
                      style: TextStyle(fontSize: 14, color: AppColors.subText),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: AppColors.sectionBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      'Đang mượn ',
                      style: TextStyle(fontSize: 14, color: AppColors.subText),
                    ),
                    Text(
                      '0 cuốn',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.bodyText,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Tổng cộng: ',
                      style: TextStyle(fontSize: 14, color: AppColors.bodyText),
                    ),
                    Text(
                      '${widget.selectedHolds.length.toString().padLeft(2, '0')}',
                      style: TextStyle(
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
        child: MyButton(text: 'Xác nhận', onPressed: () {}),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
