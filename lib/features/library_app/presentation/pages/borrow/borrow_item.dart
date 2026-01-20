import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/time_formatter.dart';

class BorrowItem extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String author;
  final String category;
  final String? note;
  final DateTime? expiresAt;
  final VoidCallback? onDelete; // Thêm callback này

  const BorrowItem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.category,
    this.note,
    this.expiresAt,
    this.onDelete, // Thêm vào constructor
  });

  @override
  State<BorrowItem> createState() => _BorrowItemState();
}

class _BorrowItemState extends State<BorrowItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: AppColors.sectionBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            if (widget.expiresAt != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: Text(
                  TimeFormatter.formatRemainingTime(widget.expiresAt!),
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            Row(
              children: [
                // Book Image
                Expanded(
                  flex: 1,
                  child: Container(
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryButton,
                    ),
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
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
                        errorWidget: (context, url, error) => Container(
                          width: double.infinity,
                          height: 300,
                          color: AppColors.hover,
                          child: Center(
                            child: Icon(
                              Icons.book,
                              color: AppColors.buttonPrimaryText,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Book Info
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.bodyText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.author,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.subText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryButton,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          widget.category,
                          style: const TextStyle(
                            color: AppColors.buttonPrimaryText,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (widget.note != null)
                        Text(
                          widget.note!,
                          style: const TextStyle(color: AppColors.subText),
                        ),
                    ],
                  ),
                ),
                if (widget.onDelete != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: widget.onDelete, // Gán callback xóa vào đây
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
