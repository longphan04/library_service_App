import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/borrow_ticket.dart';
import '../../../domain/usecases/borrow_ticket_usecase.dart';
import '../../bloc/borrow/borrow_ticket_bloc.dart';
import 'borrow_history_item.dart';

class BorrowHistoryPage extends StatefulWidget {
  const BorrowHistoryPage({super.key});

  @override
  State<BorrowHistoryPage> createState() => _BorrowHistoryPageState();
}

class _BorrowHistoryPageState extends State<BorrowHistoryPage> {
  List<String> categories = [
    'Tất cả',
    'Đang chờ',
    'Đã duyệt',
    'Đã mượn',
    'Đã trả',
    'Quá hạn',
    'Đã hủy',
  ];
  int indexCategory = 0;

  @override
  void initState() {
    super.initState();
    context.read<BorrowTicketListBloc>().add(LoadBorrowTicketsEvent());
  }

  List<Ticket> _filterTickets(List<Ticket> tickets) {
    if (indexCategory == 0) return tickets; // Tất cả
    final statusMap = {
      1: TicketStatus.pending,
      2: TicketStatus.approved,
      3: TicketStatus.pickedUp,
      4: TicketStatus.returned,
      5: TicketStatus.overdue,
      6: TicketStatus.cancelled,
    };
    return tickets
        .where((ticket) => ticket.status == statusMap[indexCategory])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.navBackground,
        title: Text(
          'Lịch sử mượn sách',
          style: TextStyle(
            color: AppColors.titleText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<BorrowTicketListBloc, BorrowTicketState>(
        builder: (context, state) {
          if (state is BorrowTicketListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BorrowTicketListFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: TextStyle(color: AppColors.subText),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BorrowTicketListBloc>().add(
                        LoadBorrowTicketsEvent(),
                      );
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state is BorrowTicketListLoaded) {
            final filteredTickets = _filterTickets(state.tickets);

            return Stack(
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
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemCount: categories.length,
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 72,
                  child: filteredTickets.isEmpty
                      ? Center(
                          child: Text(
                            'Không có lịch sử mượn sách',
                            style: TextStyle(color: AppColors.subText),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredTickets.length,
                          itemBuilder: (context, index) {
                            return BlocProvider(
                              create: (context) =>
                                  BorrowTicketBloc(
                                    getIt<GetBorrowTicketDetailUseCase>(),
                                  )..add(
                                    LoadBorrowTicketDetailEvent(
                                      filteredTickets[index].id,
                                    ),
                                  ),
                              child: BorrowTicketCard(
                                ticket: filteredTickets[index],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return Container(
            color: AppColors.primaryButton,
            height: 50,
            width: 50,
          );
        },
      ),
    );
  }
}
