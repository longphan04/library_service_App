import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/time_formatter.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/entities/book_hold.dart';
import 'detail_page.dart';

class BookCard extends StatefulWidget {
  final Book book;
  final BookHold? bookHold;
  final double? score;
  final bool isShelfMode;
  final bool isSelected;
  final void Function(bool)? onSelectionChanged;

  const BookCard({
    super.key,
    required this.book,
    this.bookHold,
    this.score,
    this.isShelfMode = false,
    this.isSelected = false,
    this.onSelectionChanged,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  String get remainingTime => widget.bookHold != null
      ? TimeFormatter.formatRemainingTime(widget.bookHold!.expiresAt)
      : '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              bookId: widget.book.bookId,
              initialCoverUrl: widget.book.coverUrl ?? '',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              flex: widget.isShelfMode ? 5 : 2,
              child: Stack(
                children: [
                  // Ảnh bìa full
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryButton,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: widget.book.coverUrl != null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: widget.book.coverUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryButton,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.broken_image,
                                      color: AppColors.subText,
                                    ),
                              ),
                            )
                          : const Icon(
                              Icons.book,
                              size: 50,
                              color: AppColors.subText,
                            ),
                    ),
                  ),

                  if (widget.score != null && widget.score! > 0)
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryButton.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amberAccent,
                              size: 14,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${(widget.score! * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info section
            Expanded(
              flex: widget.isShelfMode ? 4 : 1,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.book.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Author
                    Text(
                      widget.book.authors != null &&
                              widget.book.authors!.isNotEmpty
                          ? widget.book.authors![0].name +
                                (widget.book.authors!.length > 1
                                    ? ' + ${widget.book.authors!.length - 1}'
                                    : '')
                          : 'Không rõ',

                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Category chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryButton,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        widget.book.categories != null &&
                                widget.book.categories!.isNotEmpty
                            ? widget.book.categories![0].name +
                                  (widget.book.categories!.length > 1
                                      ? ' + ${widget.book.categories!.length - 1}'
                                      : '')
                            : 'Không rõ',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.buttonPrimaryText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (!widget.isShelfMode) const Spacer(),
                    // Available count
                    Align(
                      alignment: !widget.isShelfMode
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(
                        widget.isShelfMode
                            ? widget.bookHold?.copyNote ?? ''
                            : (widget.book.availableCopies != null &&
                                  widget.book.availableCopies! > 0)
                            ? 'Còn sách'
                            : (widget.book.availableCopies != null &&
                                  widget.book.availableCopies! <= 0)
                            ? 'Hết sách'
                            : '',
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.isShelfMode
                              ? AppColors.subText
                              : (widget.book.availableCopies != null &&
                                    widget.book.availableCopies! > 0)
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),

                    if (widget.isShelfMode) ...[
                      const Spacer(),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              checkColor: AppColors.sectionBackground,
                              activeColor: AppColors.primaryButton,
                              value: widget.isSelected,
                              onChanged: (value) {
                                widget.onSelectionChanged?.call(value ?? false);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide(
                                color: AppColors.primaryButton,
                                width: 1,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            remainingTime,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
