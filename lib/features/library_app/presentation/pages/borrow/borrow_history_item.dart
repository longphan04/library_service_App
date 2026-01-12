import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/date_formatter.dart';
import 'borrow_history_detail_page.dart';
import 'borrow_history_page.dart';

class BorrowRecordCard extends StatelessWidget {
  final BorrowRecord record;

  const BorrowRecordCard({super.key, required this.record});

  Color _getStatusColor() {
    switch (record.status) {
      case BorrowStatus.returned:
        return const Color(0xFF4CAF50);
      case BorrowStatus.pending:
        return const Color(0xFFFF9800);
      case BorrowStatus.borrowed:
        return const Color(0xFF2196F3);
      case BorrowStatus.overdue:
        return const Color(0xFFF44336);
      case BorrowStatus.approved:
        return const Color(0xFF9C27B0);
      case BorrowStatus.cancelled:
        return const Color(0xFF757575);
    }
  }

  String _getStatusText() {
    switch (record.status) {
      case BorrowStatus.returned:
        return 'Đã trả';
      case BorrowStatus.pending:
        return 'Đang chờ';
      case BorrowStatus.borrowed:
        return 'Đang mượn';
      case BorrowStatus.overdue:
        return 'Quá hạn';
      case BorrowStatus.approved:
        return 'Đã chấp nhận';
      case BorrowStatus.cancelled:
        return 'Đã hủy';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BorrowHistoryDetailPage(record: record),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.sectionBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  record.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleText,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ...List.generate(
                  record.bookCount > 3 ? 3 : record.bookCount,
                  (index) => Container(
                    width: 60,
                    height: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryButton,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                if (record.bookCount > 3)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryButton.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        '+${record.bookCount - 3}',
                        style: TextStyle(
                          color: AppColors.buttonSecondaryText,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            if (record.status == BorrowStatus.pending) ...[
              Text(
                'Đang chờ xác nhận',
                style: TextStyle(fontSize: 14, color: AppColors.subText),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primaryButton),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Hủy đơn',
                    style: TextStyle(
                      color: AppColors.buttonSecondaryText,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ] else if (record.status == BorrowStatus.borrowed) ...[
              Text(
                'Hạn: ${formatDate(record.dueDate!)}',
                style: TextStyle(fontSize: 14, color: AppColors.subText),
              ),
              if (!record.hasRequestedExtension) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryButton),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      'Gia hạn',
                      style: TextStyle(
                        color: AppColors.buttonSecondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ] else
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Đã yêu cầu gia hạn',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.subText,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ] else if (record.status == BorrowStatus.returned) ...[
              Text(
                'Hạn: ${formatDate(record.dueDate!)}',
                style: TextStyle(fontSize: 14, color: AppColors.subText),
              ),
              Text(
                'Đã trả: ${formatDate(record.returnDate!)}',
                style: TextStyle(fontSize: 14, color: AppColors.subText),
              ),
              Text(
                'Đã mượn: ${record.daysBorrowed} ngày',
                style: TextStyle(fontSize: 14, color: AppColors.subText),
              ),
            ] else if (record.status == BorrowStatus.overdue) ...[
              Text(
                'Hạn: ${formatDate(record.dueDate!)}',
                style: TextStyle(fontSize: 14, color: AppColors.subText),
              ),
              Text(
                'Quá hạn: ${record.daysOverdue} ngày',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFF44336),
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!record.hasRequestedExtension) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryButton),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      'Gia hạn',
                      style: TextStyle(
                        color: AppColors.buttonSecondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Đã yêu cầu gia hạn',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.subText,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ] else if (record.status == BorrowStatus.approved) ...[
              Text(
                'Đã được chấp nhận, vui lòng đến thư viện để nhận sách',
                style: TextStyle(fontSize: 14, color: AppColors.subText),
              ),
            ] else if (record.status == BorrowStatus.cancelled) ...[
              Text(
                'Yêu cầu đã bị hủy',
                style: TextStyle(fontSize: 14, color: AppColors.subText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
