import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/usecases/borrow_ticket_usecase.dart';
import '../../bloc/borrow/borrow_ticket_bloc.dart';
import 'borrow_history_item.dart';

class BorrowHistoryPage extends StatefulWidget {
  const BorrowHistoryPage({super.key});

  @override
  State<BorrowHistoryPage> createState() => _BorrowHistoryPageState();
}

class _BorrowHistoryPageState extends State<BorrowHistoryPage> {
  final List<Map<String, String?>> statusFilters = [
    {'label': 'Tất cả', 'value': null},
    {'label': 'Đang chờ', 'value': 'pending'},
    {'label': 'Đã duyệt', 'value': 'approved'},
    {'label': 'Đã mượn', 'value': 'picked_up'},
    {'label': 'Đã trả', 'value': 'returned'},
    {'label': 'Đã hủy', 'value': 'cancelled'},
  ];

  int indexCategory = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<BorrowTicketListBloc>().add(const LoadBorrowTicketsEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<BorrowTicketListBloc>().add(
        const LoadMoreBorrowTicketsEvent(),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  void _onStatusFilterChanged(int index) {
    if (indexCategory == index) return;
    setState(() {
      indexCategory = index;
    });
    final statusValue = statusFilters[index]['value'];
    context.read<BorrowTicketListBloc>().add(
      ChangeTicketStatusFilterEvent(statusValue),
    );
  }

  Future<void> _onRefresh() async {
    context.read<BorrowTicketListBloc>().add(const RefreshBorrowTicketsEvent());
    await Future.delayed(const Duration(milliseconds: 500));
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
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
                    onTap: () => _onStatusFilterChanged(index),
                    child: Center(
                      child: Text(
                        statusFilters[index]['label']!,
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
                itemCount: statusFilters.length,
              ),
            ),

            Expanded(
              child: BlocBuilder<BorrowTicketListBloc, BorrowTicketState>(
                builder: (context, state) {
                  return _buildScrollableContent(state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableContent(BorrowTicketState state) {
    if (state is BorrowTicketListLoaded && state.tickets.isNotEmpty) {
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: state.tickets.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.tickets.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return BlocProvider(
            create: (context) =>
                BorrowTicketBloc(getIt<GetBorrowTicketDetailUseCase>())
                  ..add(LoadBorrowTicketDetailEvent(state.tickets[index].id)),
            child: BorrowTicketCard(ticket: state.tickets[index]),
          );
        },
      );
    }

    Widget content;
    if (state is BorrowTicketListLoading) {
      content = const CircularProgressIndicator();
    } else if (state is BorrowTicketListFailure) {
      content = Text(
        state.message,
        style: TextStyle(color: AppColors.subText),
        textAlign: TextAlign.center,
      );
    } else {
      content = Text(
        'Không có lịch sử mượn sách',
        style: TextStyle(color: AppColors.subText),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: content),
          ),
        );
      },
    );
  }
}
