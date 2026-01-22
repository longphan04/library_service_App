import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../domain/entities/borrow_ticket.dart';
import '../../bloc/borrow/borrow_ticket_bloc.dart';
import '../../widgets/confirm_widget.dart';
import '../../widgets/my_button.dart';
import '../book/detail_page.dart';

class BorrowHistoryDetailPage extends StatefulWidget {
  final Ticket ticket;
  final TicketDetail record;

  const BorrowHistoryDetailPage({
    super.key,
    required this.ticket,
    required this.record,
  });

  @override
  State<BorrowHistoryDetailPage> createState() =>
      _BorrowHistoryDetailPageState();
}

class _BorrowHistoryDetailPageState extends State<BorrowHistoryDetailPage> {
  bool _isExpanded = false;

  Color _getStatusColor() {
    switch (widget.record.status) {
      case TicketStatus.returned:
        return const Color(0xFF4CAF50);
      case TicketStatus.pending:
        return const Color(0xFFFF9800);
      case TicketStatus.pickedUp:
        return const Color(0xFF2196F3);
      case TicketStatus.overdue:
        return const Color(0xFFF44336);
      case TicketStatus.approved:
        return const Color(0xFF9C27B0);
      case TicketStatus.cancelled:
        return const Color(0xFF757575);
    }
  }

  String _getStatusText() {
    switch (widget.record.status) {
      case TicketStatus.returned:
        return 'Đã trả';
      case TicketStatus.pending:
        return 'Đang chờ';
      case TicketStatus.pickedUp:
        return 'Đã mượn';
      case TicketStatus.overdue:
        return 'Quá hạn';
      case TicketStatus.approved:
        return 'Đã chấp nhận';
      case TicketStatus.cancelled:
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
                          widget.ticket.code,
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
                    const SizedBox(height: 10),
                    Text(
                      'Ngày yêu cầu: ${formatDate(widget.ticket.requestedAt)}',
                      style: TextStyle(fontSize: 14, color: AppColors.subText),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    // Book list
                    ...List.generate(
                      _isExpanded
                          ? widget.record.items.length
                          : (widget.record.items.length > 3
                                ? 2
                                : widget.record.items.length),
                      (index) => GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              bookId: widget.record.items[index].book.bookId,
                              initialCoverUrl:
                                  widget.record.items[index].book.coverUrl ??
                                  '',
                            ),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        widget
                                            .record
                                            .items[index]
                                            .book
                                            .coverUrl ??
                                        '',
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
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          color: AppColors.primaryButton,
                                          child: Center(
                                            child: Icon(
                                              Icons.book,
                                              color:
                                                  AppColors.buttonPrimaryText,
                                              size: 60,
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.record.items[index].book.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.titleText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.record.items.length > 3)
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
                    if (widget.record.status != TicketStatus.pending &&
                        widget.record.status != TicketStatus.approved &&
                        widget.record.status != TicketStatus.cancelled) ...[
                      _buildInfoRow(
                        'Ngày mượn:',
                        formatDate(widget.record.requestedAt),
                      ),
                      _buildInfoRow(
                        'Hạn trả:',
                        formatDate(widget.record.dueDate ?? DateTime.now()),
                      ),
                      if (widget.record.status == TicketStatus.returned)
                        _buildInfoRow(
                          'Đã trả:',
                          formatDate(
                            widget.record.approvedAt ?? DateTime.now(),
                          ),
                        ),
                      _buildInfoRow(
                        'Số lượng sách:',
                        '${widget.record.items.length}',
                      ),
                      if (widget.record.status == TicketStatus.returned)
                        _buildInfoRow(
                          'Đã mượn:',
                          '${widget.record.approvedAt} ngày',
                        ),
                      if (widget.record.status == TicketStatus.overdue)
                        _buildInfoRow(
                          'Quá hạn:',
                          '${widget.record.approvedAt} ngày',
                          isError: true,
                        ),
                    ] else if (widget.record.status ==
                        TicketStatus.pending) ...[
                      Text(
                        'Đơn mượn sách của bạn đang chờ xác nhận từ thư viện',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.bodyText,
                        ),
                      ),
                    ] else if (widget.record.status ==
                        TicketStatus.approved) ...[
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
                        'Vui lòng đến thư viện để nhận sách trước ngày ${formatDate(widget.record.pickupExpiresAt ?? DateTime.now())}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.bodyText,
                        ),
                      ),
                    ] else if (widget.record.status ==
                        TicketStatus.cancelled) ...[
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
                    if (widget.record.status != TicketStatus.pending &&
                        widget.record.status != TicketStatus.cancelled) ...[
                      const SizedBox(height: 24),
                      _buildTimelineItem(
                        'Đặt sách:',
                        formatDate(widget.record.requestedAt),
                        true,
                      ),
                      if (widget.record.status == TicketStatus.approved)
                        _buildTimelineItem(
                          'Chấp nhận:',
                          formatDate(
                            widget.record.approvedAt ?? DateTime.now(),
                          ),
                          true,
                        ),
                      if (widget.record.status == TicketStatus.pickedUp ||
                          widget.record.status == TicketStatus.overdue ||
                          widget.record.status == TicketStatus.returned)
                        _buildTimelineItem(
                          'Nhận sách:',
                          formatDate(
                            widget.record.pickedUpAt ?? DateTime.now(),
                          ),
                          true,
                        ),
                      if (widget.record.status == TicketStatus.returned)
                        _buildTimelineItem(
                          'Đã trả:',
                          formatDate(
                            widget.record.pickedUpAt ?? DateTime.now(),
                          ),
                          false,
                        ),
                    ],

                    // Action buttons
                    if (widget.record.status == TicketStatus.pending ||
                        (widget.record.status == TicketStatus.pickedUp) ||
                        (widget.record.status == TicketStatus.overdue))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        child: Center(
                          child:
                              BlocConsumer<
                                BorrowTicketActionBloc,
                                BorrowTicketState
                              >(
                                listener: (context, state) {
                                  if (state is BorrowTicketActionFailure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                  if (state is BorrowTicketActionSuccess) {
                                    Navigator.of(context).pop();
                                    // Refresh list
                                    context.read<BorrowTicketListBloc>().add(
                                      RefreshBorrowTicketsEvent(),
                                    );
                                  }
                                },

                                builder: (context, state) {
                                  return MyButton(
                                    text:
                                        widget.record.status ==
                                            TicketStatus.pending
                                        ? 'Hủy đơn'
                                        : 'Gia hạn',
                                    onPressed: () {
                                      final actionBloc = context
                                          .read<BorrowTicketActionBloc>();
                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return ConfirmWidget(
                                            message:
                                                widget.record.status ==
                                                    TicketStatus.pending
                                                ? "Bạn có chắc chắn muốn hủy đơn mượn sách này?"
                                                : 'Bạn chỉ được gia hạn đơn mượn sách này một lần. Bạn có chắc chắn muốn gia hạn?',
                                            onConfirm: () {
                                              if (widget.record.status ==
                                                  TicketStatus.pending) {
                                                actionBloc.add(
                                                  CancelBorrowTicketEvent(
                                                    widget.ticket.id,
                                                  ),
                                                );
                                              } else {
                                                actionBloc.add(
                                                  RenewBorrowTicketEvent(
                                                    widget.ticket.id,
                                                  ),
                                                );
                                              }
                                            },
                                          );
                                        },
                                      );
                                    },
                                    isReversedColor: true,
                                  );
                                },
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
