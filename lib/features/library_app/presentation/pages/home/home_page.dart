import 'package:flutter/material.dart';
import '../../widgets/section_header.dart';
import '../book/hot_list.dart';
import '../book/list_books.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'Hot Trend', color: Colors.orange),
            const HotList(),
            SectionHeader(
              title: 'Mới nhất',
              color: Colors.green,
              showViewAll: true,
              onViewAll: () {
                // Handle view all action
              },
            ),
            const ListBooks(itemCount: 4),
            const SizedBox(height: 10),
            SectionHeader(title: 'Đề xuất', color: Colors.blue),
            const ListBooks(itemCount: 20),
          ],
        ),
      ),
    );
  }
}
