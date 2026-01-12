import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 72, 16, 16),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const _DateDivider(text: 'Hôm nay'),
        const SizedBox(height: 12),
        _NotificationCard(
          title: 'Tiêu đề thông báo',
          content: 'Nội dung thông báo...',
          time: 'hh:mm',
        ),
        const SizedBox(height: 12),
        const _DateDivider(text: 'Hôm qua'),
        const SizedBox(height: 12),
        _NotificationCard(
          title: 'Tiêu đề thông báo',
          content: 'Nội dung thông báo...',
          time: 'hh:mm',
        ),
        const SizedBox(height: 12),
        _NotificationCard(
          title: 'Tiêu đề thông báo',
          content: 'Nội dung thông báo...',
          time: 'hh:mm',
        ),
        const SizedBox(height: 12),
        const _DateDivider(text: '01/01/2026'),
        const SizedBox(height: 12),
        _NotificationCard(
          title: 'Tiêu đề thông báo',
          content: 'Nội dung thông báo...',
          time: 'hh:mm',
        ),
        const SizedBox(height: 12),
        _NotificationCard(
          title: 'Tiêu đề thông báo',
          content: 'Nội dung thông báo...',
          time: 'hh:mm',
        ),
      ],
    );
  }
}

class _DateDivider extends StatelessWidget {
  final String text;

  const _DateDivider({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.subText,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String content;
  final String time;

  const _NotificationCard({
    required this.title,
    required this.content,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.titleText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: AppColors.subText,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: AppColors.bodyText,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
