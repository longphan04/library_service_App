import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import 'borrow_history_item.dart';

enum BorrowStatus {
  pending, // Đang chờ
  approved, // Đã chấp nhận
  borrowed, // Đang mượn
  returned, // Đã trả
  overdue, // Quá hạn
  cancelled, // Đã hủy
}

class BorrowRecord {
  final String title;
  final List<String> bookCovers;
  final int bookCount;
  final BorrowStatus status;
  final DateTime? borrowDate;
  final DateTime? dueDate;
  final DateTime? returnDate;
  final int? daysOverdue;
  final int? daysBorrowed;
  final bool hasRequestedExtension;

  BorrowRecord({
    required this.title,
    required this.bookCovers,
    required this.bookCount,
    required this.status,
    this.borrowDate,
    this.dueDate,
    this.returnDate,
    this.daysOverdue,
    this.daysBorrowed,
    this.hasRequestedExtension = false,
  });
}

class BorrowHistoryPage extends StatefulWidget {
  const BorrowHistoryPage({super.key});

  @override
  State<BorrowHistoryPage> createState() => _BorrowHistoryPageState();
}

class _BorrowHistoryPageState extends State<BorrowHistoryPage> {
  List<String> categories = [
    'Tất cả',
    'Đang chờ',
    'Đã chấp nhận',
    'Đang mượn',
    'Đã trả',
    'Quá hạn',
    'Đã hủy',
  ];
  int indexCategory = 0;

  final List<BorrowRecord> _allRecords = [
    // Returned
    BorrowRecord(
      title: '15 Tháng 12, 2025',
      bookCovers: ['', '', ''],
      bookCount: 8,
      status: BorrowStatus.returned,
      borrowDate: DateTime(2025, 12, 1),
      dueDate: DateTime(2025, 12, 15),
      returnDate: DateTime(2025, 12, 14),
      daysBorrowed: 14,
    ),
    BorrowRecord(
      title: '28 Tháng 11, 2025',
      bookCovers: ['', '', ''],
      bookCount: 5,
      status: BorrowStatus.returned,
      borrowDate: DateTime(2025, 11, 14),
      dueDate: DateTime(2025, 11, 28),
      returnDate: DateTime(2025, 11, 27),
      daysBorrowed: 14,
    ),
    BorrowRecord(
      title: '10 Tháng 11, 2025',
      bookCovers: ['', '', ''],
      bookCount: 2,
      status: BorrowStatus.returned,
      borrowDate: DateTime(2025, 10, 27),
      dueDate: DateTime(2025, 11, 10),
      returnDate: DateTime(2025, 11, 9),
      daysBorrowed: 14,
    ),
    // In process
    BorrowRecord(
      title: '5 Tháng 1, 2026',
      bookCovers: ['', '', ''],
      bookCount: 4,
      status: BorrowStatus.pending,
    ),
    BorrowRecord(
      title: '3 Tháng 1, 2026',
      bookCovers: ['', '', ''],
      bookCount: 1,
      status: BorrowStatus.pending,
    ),
    // Borrowed
    BorrowRecord(
      title: '1 Tháng 1, 2026',
      bookCovers: ['', '', ''],
      bookCount: 7,
      status: BorrowStatus.borrowed,
      borrowDate: DateTime(2026, 1, 1),
      dueDate: DateTime(2026, 1, 15),
      hasRequestedExtension: false,
    ),
    BorrowRecord(
      title: '30 Tháng 12, 2025',
      bookCovers: ['', '', ''],
      bookCount: 4,
      status: BorrowStatus.borrowed,
      borrowDate: DateTime(2025, 12, 30),
      dueDate: DateTime(2026, 1, 13),
      hasRequestedExtension: true,
    ),
    BorrowRecord(
      title: '25 Tháng 12, 2025',
      bookCovers: ['', '', ''],
      bookCount: 3,
      status: BorrowStatus.borrowed,
      borrowDate: DateTime(2025, 12, 25),
      dueDate: DateTime(2026, 1, 8),
      hasRequestedExtension: false,
    ),
    // Overdue
    BorrowRecord(
      title: '20 Tháng 12, 2025',
      bookCovers: ['', '', ''],
      bookCount: 6,
      status: BorrowStatus.overdue,
      borrowDate: DateTime(2025, 12, 6),
      dueDate: DateTime(2025, 12, 20),
      daysOverdue: 19,
      hasRequestedExtension: true,
    ),
    BorrowRecord(
      title: '5 Tháng 12, 2025',
      bookCovers: ['', '', ''],
      bookCount: 5,
      status: BorrowStatus.overdue,
      borrowDate: DateTime(2025, 11, 21),
      dueDate: DateTime(2025, 12, 5),
      daysOverdue: 34,
      hasRequestedExtension: false,
    ),
    // Approved
    BorrowRecord(
      title: '7 Tháng 1, 2026',
      bookCovers: ['', '', ''],
      bookCount: 3,
      status: BorrowStatus.approved,
      borrowDate: DateTime(2026, 1, 7),
      dueDate: DateTime(2026, 1, 21),
    ),
    BorrowRecord(
      title: '6 Tháng 1, 2026',
      bookCovers: ['', '', ''],
      bookCount: 2,
      status: BorrowStatus.approved,
      borrowDate: DateTime(2026, 1, 6),
      dueDate: DateTime(2026, 1, 20),
    ),
    // Cancelled
    BorrowRecord(
      title: '2 Tháng 1, 2026',
      bookCovers: ['', '', ''],
      bookCount: 10,
      status: BorrowStatus.cancelled,
    ),
    BorrowRecord(
      title: '18 Tháng 12, 2025',
      bookCovers: ['', '', ''],
      bookCount: 3,
      status: BorrowStatus.cancelled,
    ),
    BorrowRecord(
      title: '8 Tháng 12, 2025',
      bookCovers: ['', '', ''],
      bookCount: 1,
      status: BorrowStatus.cancelled,
    ),
  ];

  List<BorrowRecord> get _filteredRecords {
    if (indexCategory == 0) return _allRecords; // Tất cả
    final statusMap = {
      1: BorrowStatus.pending,
      2: BorrowStatus.approved,
      3: BorrowStatus.borrowed,
      4: BorrowStatus.returned,
      5: BorrowStatus.overdue,
      6: BorrowStatus.cancelled,
    };
    return _allRecords
        .where((record) => record.status == statusMap[indexCategory])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.navBackground,
        elevation: 0,
        title: Text(
          'Lịch sử mượn sách',
          style: TextStyle(
            color: AppColors.titleText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.sectionBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        indexCategory = index;
                      });
                    },
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: indexCategory == index
                              ? AppColors.primaryButton
                              : AppColors.subText,
                          fontSize: 14,
                          fontWeight: indexCategory == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemCount: categories.length,
              ),
            ),
          ),
          Positioned.fill(
            top: 72,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredRecords.length,
              itemBuilder: (context, index) {
                return BorrowRecordCard(record: _filteredRecords[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
