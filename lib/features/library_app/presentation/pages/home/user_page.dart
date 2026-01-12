import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../widgets/navigation_item.dart';
import '../borrow/borrow_history_page.dart';
import '../messages/message_page.dart';
import 'blank_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cá nhân',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.titleText,
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              decoration: BoxDecoration(
                color: AppColors.sectionBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 60, color: AppColors.icon),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'johndoe@example.com',
                    style: TextStyle(fontSize: 14, color: AppColors.subText),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Thư viện của tôi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.titleText,
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.sectionBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NavigationItem(
                    icon: Icons.history,
                    title: 'Lịch sử mượn sách',
                    page: BorrowHistoryPage(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cài đặt',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.titleText,
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.sectionBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NavigationItem(
                    icon: Icons.person_outline,
                    title: 'Thông tin cá nhân',
                    page: const BlankPage(),
                  ),
                  const SizedBox(height: 10),
                  NavigationItem(
                    icon: Icons.notifications_none_outlined,
                    title: 'Thông báo',
                    page: MessagePage(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Hỗ trợ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.sectionBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NavigationItem(
                    icon: Icons.help_outline,
                    title: 'Trung tâm hỗ trợ',
                    page: const BlankPage(),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    const SizedBox(width: 5),
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
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
