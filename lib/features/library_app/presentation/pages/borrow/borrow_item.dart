import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Reusable borrow item widget for Borrow Page and Borrow History
class BorrowItem extends StatefulWidget {
  final String title;
  final String author;
  final String category;
  final int availableCount;

  const BorrowItem({
    super.key,
    required this.title,
    required this.author,
    required this.category,
    required this.availableCount,
  });

  @override
  State<BorrowItem> createState() => _BorrowItemState();
}

class _BorrowItemState extends State<BorrowItem> {
  bool isChecked = false;
  int quantity = 1;

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
        child: Row(
          children: [
            // Book Image
            Expanded(
              flex: 1,
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(color: AppColors.primaryButton),
              ),
            ),
            const SizedBox(width: 12),
            // Book Info and Quantity
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
                    style: TextStyle(fontSize: 12, color: AppColors.subText),
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
                  Text(
                    'Còn ${widget.availableCount} cuốn',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Icon(Icons.delete, color: Colors.red, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
