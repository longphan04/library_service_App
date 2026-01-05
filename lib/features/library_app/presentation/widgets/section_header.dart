import 'package:flutter/material.dart';

/// Reusable section header with optional "View all" link
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final bool showViewAll;
  final Color color;

  const SectionHeader({
    required this.title,
    this.onViewAll,
    this.showViewAll = false,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (showViewAll && onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                'View all',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
