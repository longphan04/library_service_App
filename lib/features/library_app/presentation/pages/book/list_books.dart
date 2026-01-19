import 'package:flutter/material.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/entities/book_hold.dart';
import 'book_card.dart';

class ListBooks extends StatelessWidget {
  final List<Book>? books;
  final List<BookHold>? holds;

  final bool isShelfMode;
  final void Function(int id, bool isSelected)? onBookSelectionChanged;
  final Set<int>? selectedIds;

  const ListBooks({
    super.key,
    this.books,
    this.holds,
    this.isShelfMode = false,
    this.onBookSelectionChanged,
    this.selectedIds,
  }) : assert(
         books != null || holds != null,
         'Either books or holds must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final itemBooks = holds?.map((h) => h.book).toList() ?? books!;
    final itemCount = itemBooks.length;

    if (itemCount == 0) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.525,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final book = itemBooks[index];
        final hold = holds?[index];
        final itemId = hold?.holdId ?? book.bookId;
        final isSelected = selectedIds?.contains(itemId) ?? false;

        return BookCard(
          book: book,
          bookHold: hold,
          isShelfMode: isShelfMode,
          isSelected: isSelected,
          onSelectionChanged: isShelfMode
              ? (selected) => onBookSelectionChanged?.call(itemId, selected)
              : null,
        );
      },
    );
  }
}
