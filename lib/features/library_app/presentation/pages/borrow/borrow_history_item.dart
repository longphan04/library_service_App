import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../domain/entities/borrow_ticket.dart';
import '../../bloc/borrow/borrow_ticket_bloc.dart';
import '../../widgets/confirm_widget.dart';
import 'borrow_history_detail_page.dart';

class BorrowTicketCard extends StatefulWidget {
  final Ticket ticket;

  const BorrowTicketCard({super.key, required this.ticket});

  @override
  State<BorrowTicketCard> createState() => _BorrowTicketCardState();
}

class _BorrowTicketCardState extends State<BorrowTicketCard> {
  Color _getStatusColor() {
    switch (widget.ticket.status) {
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
    switch (widget.ticket.status) {
      case TicketStatus.returned:
        return 'Đã trả';
      case TicketStatus.pending:
        return 'Đang chờ';
      case TicketStatus.pickedUp:
        return 'Đã nhận';
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
    return BlocBuilder<BorrowTicketBloc, BorrowTicketState>(
      builder: (context, state) {
        final List<TicketItem> items = (state is BorrowTicketDetailLoaded)
            ? state.ticketDetail.items
            : [];
        return InkWell(
          onTap: () {
            if (state is BorrowTicketDetailLoaded) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BorrowHistoryDetailPage(
                      ticket: widget.ticket,
                      record: state.ticketDetail,
                    );
                  },
                ),
              );
            }
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
                      widget.ticket.code,
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
                Text(
                  'Ngày yêu cầu: ${formatDate(widget.ticket.requestedAt)}',
                  style: TextStyle(fontSize: 14, color: AppColors.subText),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 80, // Cố định chiều cao để tránh giật layout
                  child: state is BorrowTicketDetailLoading
                      ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ) // Loading nhỏ
                      : items.isNotEmpty
                      ? Row(
                          children: [
                            ...items.take(3).map((item) {
                              return Container(
                                width: 60,
                                height: 80,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl: item.book.coverUrl ?? '',
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
                              );
                            }),
                            if (items.length > 3)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryButton.withOpacity(
                                    0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    '+${items.length - 3}',
                                    style: TextStyle(
                                      color: AppColors.buttonSecondaryText,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      : const SizedBox(),
                ),
                const SizedBox(height: 10),
                const Divider(),
                if (widget.ticket.status == TicketStatus.pending) ...[
                  Text(
                    'Đang chờ xác nhận',
                    style: TextStyle(fontSize: 14, color: AppColors.subText),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: BlocConsumer<BorrowTicketListBloc, BorrowTicketState>(
                      listener: (context, state) {
                        if (state is BorrowTicketActionFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ConfirmWidget(
                                  message:
                                      'Bạn có chắc chắn muốn hủy đơn mượn sách này?',
                                  onConfirm: () {
                                    context.read<BorrowTicketListBloc>().add(
                                      CancelBorrowTicketEvent(widget.ticket.id),
                                    );
                                  },
                                );
                              },
                            );
                          },
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
                        );
                      },
                    ),
                  ),
                ] else if (widget.ticket.status == TicketStatus.pickedUp) ...[
                  Text(
                    'Hạn: ${formatDate(widget.ticket.dueDate ?? DateTime.now())}',
                    style: TextStyle(fontSize: 14, color: AppColors.subText),
                  ),
                  if (widget.ticket.renewCount == 0) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: BlocConsumer<BorrowTicketListBloc, BorrowTicketState>(
                        listener: (context, state) {
                          if (state is BorrowTicketActionFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
                        builder: (context, state) {
                          return OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ConfirmWidget(
                                    message:
                                        'Bạn chỉ được gia hạn đơn mượn sách này một lần. Bạn có chắc chắn muốn gia hạn?',
                                    onConfirm: () {
                                      context.read<BorrowTicketListBloc>().add(
                                        RenewBorrowTicketEvent(
                                          widget.ticket.id,
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.primaryButton),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
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
                          );
                        },
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
                ] else if (widget.ticket.status == TicketStatus.returned) ...[
                  Text(
                    'Hạn: ${formatDate(widget.ticket.dueDate ?? DateTime.now())}',
                    style: TextStyle(fontSize: 14, color: AppColors.subText),
                  ),
                  Text(
                    'Đã trả: ${formatDate(widget.ticket.dueDate ?? DateTime.now())}',
                    style: TextStyle(fontSize: 14, color: AppColors.subText),
                  ),
                  Text(
                    'Đã mượn: ${DateTime.now().difference(widget.ticket.dueDate ?? DateTime.now()).inDays} ngày',
                    style: TextStyle(fontSize: 14, color: AppColors.subText),
                  ),
                ] else if (widget.ticket.status == TicketStatus.overdue) ...[
                  Text(
                    'Hạn: ${formatDate(widget.ticket.dueDate!)}',
                    style: TextStyle(fontSize: 14, color: AppColors.subText),
                  ),
                  Text(
                    'Quá hạn: ${DateTime.now().difference(widget.ticket.dueDate ?? DateTime.now()).inDays} ngày',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFF44336),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else if (widget.ticket.status == TicketStatus.approved) ...[
                  Text(
                    'Đã được chấp nhận, vui lòng đến thư viện để nhận sách',
                    style: TextStyle(fontSize: 14, color: AppColors.subText),
                  ),
                ] else if (widget.ticket.status == TicketStatus.cancelled) ...[
                  Text(
                    'Yêu cầu đã bị hủy',
                    style: TextStyle(fontSize: 14, color: AppColors.subText),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
