import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/book_hold.dart';
import '../../bloc/borrow/borrow_bloc.dart';
import '../book/list_books.dart';
import '../borrow/borrow_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Set<int> _selectedHoldIds = {};
  bool _selectAll = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    context.read<BorrowBloc>().add(LoadBookHoldsEvent());
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkExpirationAndRefresh();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkExpirationAndRefresh() {
    final state = context.read<BorrowBloc>().state;
    if (state is ListBookHoldsLoaded) {
      final nowUtc = DateTime.now().toUtc();

      final expiredHolds = state.holds.where((h) {
        return h.expiresAt.toUtc().isBefore(nowUtc);
      }).toList();

      final expiredIds = expiredHolds.map((h) => h.holdId).toSet();

      if (_selectedHoldIds.any((id) => expiredIds.contains(id))) {
        setState(() {
          _selectedHoldIds.removeWhere((id) => expiredIds.contains(id));
        });
      } else {
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  void _toggleSelectAll(List<BookHold> holds) {
    setState(() {
      _selectAll = !_selectAll;
      if (_selectAll) {
        _selectedHoldIds = holds.map((h) => h.holdId).toSet();
      } else {
        _selectedHoldIds.clear();
      }
    });
  }

  void _toggleHoldSelection(int holdId) {
    setState(() {
      if (_selectedHoldIds.contains(holdId)) {
        _selectedHoldIds.remove(holdId);
      } else {
        _selectedHoldIds.add(holdId);
      }
    });
  }

  void _deleteSelectedHolds() {
    if (_selectedHoldIds.isEmpty) {
      return;
    }
    context.read<BorrowBloc>().add(
      RemoveBookHoldEvent(_selectedHoldIds.toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<BorrowBloc, BorrowState>(
        builder: (context, state) {
          if (state is ListBookHoldsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ListBookHoldsFailure) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<BorrowBloc>().add(RefreshBookHoldsEvent());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<BorrowBloc>().add(
                              LoadBookHoldsEvent(),
                            );
                          },
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          final allHolds = state is ListBookHoldsLoaded
              ? state.holds
              : <BookHold>[];

          final nowUtc = DateTime.now().toUtc();
          final holds = allHolds.where((hold) {
            return hold.expiresAt.toUtc().isAfter(nowUtc);
          }).toList();

          final currentHoldIds = holds.map((h) => h.holdId).toSet();
          if (_selectedHoldIds.isNotEmpty) {
            final validSelectedIds = _selectedHoldIds
                .where((id) => currentHoldIds.contains(id))
                .toSet();
            if (validSelectedIds.length != _selectedHoldIds.length) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _selectedHoldIds = validSelectedIds;
                  });
                }
              });
            }
          }

          final areAllSelected =
              holds.isNotEmpty && _selectedHoldIds.length == holds.length;

          if (_selectAll != areAllSelected) {
            _selectAll = areAllSelected;
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<BorrowBloc>().add(RefreshBookHoldsEvent());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Kệ sách',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: _deleteSelectedHolds,
                          icon: const Icon(Icons.delete, color: Colors.red),
                          style: IconButton.styleFrom(
                            side: const BorderSide(color: Colors.red, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (holds.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'Chưa có sách nào trong kệ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  else
                    ListBooks(
                      holds: holds,
                      isShelfMode: true,
                      selectedIds: _selectedHoldIds,
                      onBookSelectionChanged: (holdId, isSelected) {
                        _toggleHoldSelection(holdId);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<BorrowBloc, BorrowState>(
        builder: (context, state) {
          final allHolds = state is ListBookHoldsLoaded
              ? state.holds
              : <BookHold>[];

          final nowUtc = DateTime.now().toUtc();
          final holds = allHolds.where((hold) {
            return hold.expiresAt.toUtc().isAfter(nowUtc);
          }).toList();

          final selectedHolds = holds
              .where((h) => _selectedHoldIds.contains(h.holdId))
              .toList();

          // Logic check box state
          final bool isChecked =
              holds.isNotEmpty && _selectedHoldIds.length == holds.length;

          return Container(
            height: 60,
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Checkbox(
                        value: isChecked, // Dùng biến cục bộ đã tính toán
                        onChanged: holds.isEmpty
                            ? null
                            : (value) {
                                _toggleSelectAll(holds);
                              },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: const BorderSide(
                          color: AppColors.primaryButton,
                          width: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Tất cả',
                      style: TextStyle(fontSize: 14, color: AppColors.bodyText),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: selectedHolds.isEmpty
                      ? null
                      : () {
                          // Kiểm tra giới hạn 5 cuốn khi bấm mượn sách
                          if (selectedHolds.length > 5) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Bạn chỉ có thể mượn tối đa 5 cuốn sách cùng lúc',
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return BorrowPage(selectedHolds: selectedHolds);
                              },
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedHolds.isEmpty
                        ? Colors.grey
                        : AppColors.primaryButton,
                    minimumSize: const Size(0, 60),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Mượn sách (${selectedHolds.length})',
                    style: TextStyle(
                      color: AppColors.buttonPrimaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
