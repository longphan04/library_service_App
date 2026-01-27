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
  final Ticket record;

  const BorrowHistoryDetailPage({super.key, required this.record});

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
      body: SingleChildScrollView(
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
              // Mã phiếu + Trạng thái
              _buildHeader(),
              const SizedBox(height: 10),

              const Divider(),
              const SizedBox(height: 10),

              // Danh sách sách đã mượn
              _buildBookList(),
              const SizedBox(height: 16),

              // Thông tin chi tiết mượn trả
              _buildBorrowInfo(),

              // Timeline
              if (widget.record.status != TicketStatus.pending &&
                  widget.record.status != TicketStatus.cancelled) ...[
                const Divider(),
                const SizedBox(height: 24),
                _buildTimeline(),
              ],

              // Nút bấm hành động
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.record.code,
              style: TextStyle(
                color: AppColors.titleText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
          'Ngày yêu cầu: ${formatDate(widget.record.requestedAt)}',
          style: TextStyle(fontSize: 14, color: AppColors.subText),
        ),
      ],
    );
  }

  Widget _buildBookList() {
    final totalItems = widget.record.items!.length;
    final displayCount = _isExpanded || totalItems <= 3 ? totalItems : 2;

    return Column(
      children: [
        ...List.generate(displayCount, (index) {
          final item = widget.record.items![index];
          return _buildBookItem(item);
        }),
        if (totalItems > 3)
          Center(
            child: GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _isExpanded ? 'Ẩn bớt' : 'Xem thêm',
                  style: TextStyle(
                    color: AppColors.primaryButton,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBookItem(TicketItem item) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(
            bookId: item.book.bookId,
            initialCoverUrl: item.book.coverUrl ?? '',
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: item.book.coverUrl ?? '',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.primaryButton,
                    child: Center(
                      child: Icon(
                        Icons.book,
                        color: AppColors.buttonPrimaryText,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.book.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBorrowInfo() {
    // Pending
    if (widget.record.status == TicketStatus.pending) {
      return Text(
        'Đơn mượn sách của bạn đang chờ xác nhận từ thư viện',
        style: TextStyle(fontSize: 14, color: AppColors.bodyText),
      );
    }

    // Approved
    if (widget.record.status == TicketStatus.approved) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            style: TextStyle(fontSize: 14, color: AppColors.bodyText),
          ),
        ],
      );
    }

    // Cancelled
    if (widget.record.status == TicketStatus.cancelled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            style: TextStyle(fontSize: 14, color: AppColors.subText),
          ),
        ],
      );
    }

    // PickedUp, Returned, Overdue
    return Column(
      children: [
        _buildInfoRow(
          'Ngày mượn:',
          formatDate(
            widget.record.pickedUpAt ??
                widget.record.approvedAt ??
                widget.record.requestedAt,
          ),
        ),
        _buildInfoRow(
          'Hạn trả:',
          formatDate(widget.record.dueDate ?? DateTime.now()),
        ),
        if (widget.record.status == TicketStatus.returned)
          _buildInfoRow(
            'Đã trả:',
            formatDate(widget.record.returnedAt ?? DateTime.now()),
          ),
        _buildInfoRow('Số lượng sách:', '${widget.record.items!.length}'),

        if (widget.record.status == TicketStatus.returned)
          _buildInfoRow(
            'Đã mượn:',
            '${(widget.record.returnedAt ?? DateTime.now()).difference(widget.record.pickedUpAt ?? widget.record.approvedAt ?? widget.record.requestedAt).inDays} ngày',
          ),

        if (widget.record.status == TicketStatus.overdue)
          _buildInfoRow(
            'Quá hạn:',
            '${(DateTime.now()).difference(widget.record.dueDate ?? DateTime.now()).inDays} ngày',
            isError: true,
          ),
      ],
    );
  }

  Widget _buildTimeline() {
    final isApproved = [
      TicketStatus.approved,
      TicketStatus.pickedUp,
      TicketStatus.overdue,
      TicketStatus.returned,
    ].contains(widget.record.status);

    final isPickedUp = [
      TicketStatus.pickedUp,
      TicketStatus.overdue,
      TicketStatus.returned,
    ].contains(widget.record.status);

    final isReturned = widget.record.status == TicketStatus.returned;

    return Column(
      children: [
        _buildTimelineItem(
          'Đặt sách:',
          formatDate(widget.record.requestedAt),
          isFirst: true,
          hasLine: isApproved,
        ),

        if (isApproved)
          _buildTimelineItem(
            'Chấp nhận:',
            formatDate(widget.record.approvedAt ?? DateTime.now()),
            isFirst: false,
            hasLine: isPickedUp,
          ),

        if (isPickedUp)
          _buildTimelineItem(
            'Nhận sách:',
            formatDate(widget.record.pickedUpAt ?? DateTime.now()),
            isFirst: false,
            hasLine: isReturned,
          ),

        if (isReturned)
          _buildTimelineItem(
            'Đã trả:',
            formatDate(widget.record.returnedAt ?? DateTime.now()),
            isFirst: false,
            hasLine: false,
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return BlocConsumer<BorrowTicketActionBloc, BorrowTicketState>(
      listener: (context, state) {
        if (state is BorrowTicketActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
        if (state is BorrowTicketActionSuccess) {
          Navigator.of(context).pop();
          context.read<BorrowTicketListBloc>().add(RefreshBorrowTicketsEvent());
        }
      },
      builder: (context, state) {
        final isPending = widget.record.status == TicketStatus.pending;
        final canRenew =
            widget.record.status == TicketStatus.pickedUp &&
            widget.record.renewCount == 0;

        if (!isPending && !canRenew) return const SizedBox();

        return Column(
          children: [
            const SizedBox(height: 20),
            MyButton(
              text: isPending ? 'Hủy đơn' : 'Gia hạn',
              isReversedColor: true,
              onPressed: () {
                final actionBloc = context.read<BorrowTicketActionBloc>();
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return ConfirmWidget(
                      message: isPending
                          ? "Bạn có chắc chắn muốn hủy đơn mượn sách này?"
                          : 'Bạn chỉ được gia hạn đơn mượn sách này một lần. Bạn có chắc chắn muốn gia hạn?',
                      onConfirm: () {
                        if (isPending) {
                          actionBloc.add(
                            CancelBorrowTicketEvent(widget.record.id),
                          );
                        } else {
                          actionBloc.add(
                            RenewBorrowTicketEvent(widget.record.id),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ],
        );
      },
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

  Widget _buildTimelineItem(
    String label,
    String date, {
    required bool isFirst,
    required bool hasLine,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 12,
            child: Column(
              children: [
                Expanded(
                  child: isFirst
                      ? const SizedBox()
                      : Container(width: 2, color: AppColors.border),
                ),

                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.primaryButton,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.sectionBackground,
                      width: 2,
                    ),
                  ),
                ),

                Expanded(
                  child: hasLine
                      ? Container(width: 2, color: AppColors.border)
                      : const SizedBox(),
                ),

                SizedBox(
                  height: 24,
                  child: hasLine
                      ? Center(
                          child: Container(width: 2, color: AppColors.border),
                        )
                      : null,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
