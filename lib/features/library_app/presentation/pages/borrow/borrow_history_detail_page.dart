import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../widgets/my_button.dart';
import 'borrow_history_page.dart';

class BorrowHistoryDetailPage extends StatefulWidget {
  final BorrowRecord record;

  const BorrowHistoryDetailPage({super.key, required this.record});

  @override
  State<BorrowHistoryDetailPage> createState() =>
      _BorrowHistoryDetailPageState();
}

class _BorrowHistoryDetailPageState extends State<BorrowHistoryDetailPage> {
  bool _isExpanded = false;

  Color _getStatusColor() {
    switch (widget.record.status) {
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
    switch (widget.record.status) {
      case BorrowStatus.returned:
        return 'Đã trả';
      case BorrowStatus.pending:
        return 'Đang chờ';
      case BorrowStatus.borrowed:
        return 'Đã mượn';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.titleText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Chi tiết mượn sách',
          style: TextStyle(
            color: AppColors.titleText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.sectionBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.record.title,
                          style: TextStyle(
                            color: AppColors.titleText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 10),
                    // Book list
                    ...List.generate(
                      _isExpanded
                          ? widget.record.bookCount
                          : (widget.record.bookCount > 3
                                ? 2
                                : widget.record.bookCount),
                      (index) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.primaryButton,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tiêu đề sách',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.titleText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tác giả',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.subText,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryButton,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Danh mục',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.buttonPrimaryText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.record.bookCount > 3)
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Text(
                            _isExpanded ? 'Ẩn bớt' : 'Xem thêm',
                            style: TextStyle(
                              color: AppColors.primaryButton,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Borrow info
                    if (widget.record.status != BorrowStatus.pending &&
                        widget.record.status != BorrowStatus.approved &&
                        widget.record.status != BorrowStatus.cancelled) ...[
                      _buildInfoRow(
                        'Ngày mượn:',
                        formatDate(widget.record.borrowDate!),
                      ),
                      _buildInfoRow(
                        'Hạn trả:',
                        formatDate(widget.record.dueDate!),
                      ),
                      if (widget.record.status == BorrowStatus.returned)
                        _buildInfoRow(
                          'Đã trả:',
                          formatDate(widget.record.returnDate!),
                        ),
                      _buildInfoRow(
                        'Số lượng sách:',
                        '${widget.record.bookCount}',
                      ),
                      if (widget.record.status == BorrowStatus.returned)
                        _buildInfoRow(
                          'Đã mượn:',
                          '${widget.record.daysBorrowed} ngày',
                        ),
                      if (widget.record.status == BorrowStatus.overdue)
                        _buildInfoRow(
                          'Quá hạn:',
                          '${widget.record.daysOverdue} ngày',
                          isError: true,
                        ),
                    ] else if (widget.record.status ==
                        BorrowStatus.pending) ...[
                      Text(
                        'Đơn mượn sách của bạn đang chờ xác nhận từ thư viện',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.bodyText,
                        ),
                      ),
                    ] else if (widget.record.status ==
                        BorrowStatus.approved) ...[
                      Text(
                        'Đơn mượn sách đã được chấp nhận',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.titleText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Vui lòng đến thư viện để nhận sách trước ngày ${formatDate(widget.record.dueDate!)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.bodyText,
                        ),
                      ),
                    ] else if (widget.record.status ==
                        BorrowStatus.cancelled) ...[
                      Text(
                        'Đơn mượn sách đã bị hủy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.subText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bạn có thể tạo đơn mượn mới nếu cần',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.subText,
                        ),
                      ),
                    ],

                    const Divider(),

                    // Timeline
                    if (widget.record.status != BorrowStatus.pending &&
                        widget.record.status != BorrowStatus.cancelled) ...[
                      const SizedBox(height: 24),
                      _buildTimelineItem(
                        'Đặt sách:',
                        formatDate(widget.record.borrowDate!),
                        true,
                      ),
                      if (widget.record.status == BorrowStatus.approved)
                        _buildTimelineItem(
                          'Chấp nhận:',
                          formatDate(widget.record.borrowDate!),
                          true,
                        ),
                      if (widget.record.status == BorrowStatus.borrowed ||
                          widget.record.status == BorrowStatus.overdue ||
                          widget.record.status == BorrowStatus.returned)
                        _buildTimelineItem(
                          'Nhận sách:',
                          formatDate(widget.record.borrowDate!),
                          true,
                        ),
                      if (widget.record.status == BorrowStatus.returned)
                        _buildTimelineItem(
                          'Đã trả:',
                          formatDate(widget.record.returnDate!),
                          false,
                        ),
                    ],

                    // Action buttons
                    if (widget.record.status == BorrowStatus.pending ||
                        (widget.record.status == BorrowStatus.borrowed &&
                            !widget.record.hasRequestedExtension) ||
                        (widget.record.status == BorrowStatus.overdue &&
                            !widget.record.hasRequestedExtension))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        child: Center(
                          child: MyButton(
                            text: widget.record.status == BorrowStatus.pending
                                ? 'Hủy đơn'
                                : 'Gia hạn',
                            onPressed: () {},
                            isReversedColor: true,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: AppColors.subText)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isError ? const Color(0xFFF44336) : AppColors.bodyText,
              fontWeight: isError ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String label, String date, bool hasLine) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.primaryButton,
                shape: BoxShape.circle,
              ),
            ),
            if (hasLine)
              Container(width: 2, height: 40, color: AppColors.border),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.titleText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              date,
              style: TextStyle(fontSize: 14, color: AppColors.subText),
            ),
          ],
        ),
      ],
    );
  }
}
