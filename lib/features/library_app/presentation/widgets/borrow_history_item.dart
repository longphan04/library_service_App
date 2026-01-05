import 'package:flutter/material.dart';

/// Reusable borrow history item widget showing past borrowing records
class BorrowHistoryItem extends StatelessWidget {
  final List<String> bookImages;
  final int totalBooks;
  final String borrowDate;
  final String dueDate;
  final String returnDate;
  final String status; // 'Returned', 'In process', 'Borrowed', 'Overdue'
  final int? overdueDays;
  final VoidCallback onDetails;
  final VoidCallback? onCancel;

  const BorrowHistoryItem({
    required this.bookImages,
    required this.totalBooks,
    required this.borrowDate,
    required this.dueDate,
    required this.returnDate,
    required this.status,
    this.overdueDays,
    required this.onDetails,
    this.onCancel,
    super.key,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'returned':
        return Colors.green;
      case 'in process':
        return Colors.orange;
      case 'borrowed':
        return Colors.blue;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  borrowDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Book thumbnails
            Row(
              children: [
                ...List.generate(
                  bookImages.length > 3 ? 3 : bookImages.length,
                  (index) => Container(
                    width: 50,
                    height: 75,
                    margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                if (totalBooks > 3)
                  Container(
                    width: 50,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        '+${totalBooks - 3}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Info and Actions
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Due: $dueDate',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Return: $returnDate',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    if (status == 'Overdue' && overdueDays != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Overdue: $overdueDays days',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    OutlinedButton(
                      onPressed: onDetails,
                      child: const Text('Details'),
                    ),
                    if (status == 'In process' && onCancel != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: OutlinedButton(
                          onPressed: onCancel,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red),
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
