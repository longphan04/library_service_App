import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../domain/entities/notification.dart' as entities;
import '../../bloc/message/notification_bloc.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<NotificationBloc>();
    // Fetch notifications và mark all as read khi vào trang
    bloc.add(const FetchNotifications());
    bloc.add(const MarkAllNotificationsAsRead());
  }

  Map<String, List<entities.Notification>> _groupNotificationsByDate(
    List<entities.Notification> notifications,
  ) {
    final Map<String, List<entities.Notification>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var notification in notifications) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      String dateKey;
      if (notificationDate == today) {
        dateKey = 'Hôm nay';
      } else if (notificationDate == yesterday) {
        dateKey = 'Hôm qua';
      } else {
        dateKey = formatDate(notification.createdAt);
      }

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(notification);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NotificationError) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationBloc>().add(RefreshNotifications());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (state is NotificationLoaded) {
          if (state.notifications.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationBloc>().add(RefreshNotifications());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: AppColors.subText,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Không có thông báo',
                      style: TextStyle(fontSize: 16, color: AppColors.subText),
                    ),
                  ],
                ),
              ),
            );
          }

          final groupedNotifications = _groupNotificationsByDate(
            state.notifications,
          );

          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationBloc>().add(RefreshNotifications());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 72, 16, 16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: groupedNotifications.length * 2,
              itemBuilder: (context, index) {
                if (index.isEven) {
                  // Date divider
                  final dateKey = groupedNotifications.keys.elementAt(
                    index ~/ 2,
                  );
                  return Column(
                    children: [
                      if (index > 0) const SizedBox(height: 12),
                      _DateDivider(text: dateKey),
                      const SizedBox(height: 12),
                    ],
                  );
                } else {
                  // Notification cards
                  final dateKey = groupedNotifications.keys.elementAt(
                    index ~/ 2,
                  );
                  final notifications = groupedNotifications[dateKey]!;
                  return Column(
                    children: notifications
                        .map(
                          (notification) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _NotificationCard(
                              title: notification.title,
                              content: notification.content,
                              time: DateFormat(
                                'HH:mm',
                              ).format(notification.createdAt),
                              isRead: notification.isRead,
                            ),
                          ),
                        )
                        .toList(),
                  );
                }
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
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
  final bool isRead;

  const _NotificationCard({
    required this.title,
    required this.content,
    required this.time,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead
            ? Colors.white
            : AppColors.secondaryButton.withOpacity(0.3),
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
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
