import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/ai_book_source.dart';

class AIBookCard extends StatelessWidget {
  final AIBookSource source;

  const AIBookCard({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              source.title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Author
            Text(
              source.authors.isNotEmpty ? source.authors : 'Không rõ',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryButton,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                source.category.isNotEmpty ? source.category : 'Không rõ',
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.buttonPrimaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            // Score indicator
            Row(
              children: [
                Icon(Icons.star, size: 12, color: Colors.amber.shade600),
                const SizedBox(width: 2),
                Text(
                  '${(source.score * 100).toStringAsFixed(0)}% phù hợp',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
