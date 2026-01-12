import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/my_button.dart';
import '../../widgets/search_app_bar.dart';
import '../../widgets/section_header.dart';
import 'list_books.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String author;
  final String category;
  final int availableCount;

  const DetailPage({
    super.key,
    required this.title,
    required this.author,
    required this.category,
    required this.availableCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navBackground,
      appBar: SearchAppBar(onSearchChanged: (query) {}, showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image
            Container(
              width: double.infinity,
              height: 500,
              color: AppColors.hover,
            ),
            // Book Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  Row(
                    children: [
                      Text(
                        'Còn $availableCount cuốn',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        ' | 123 Cuốn đã mượn',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.subText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(thickness: 10, color: AppColors.background),
            // Details Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chi tiết sách',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Divider(thickness: 2, color: AppColors.background),
                  _buildDetailRow('Thể loại', category),
                  Divider(thickness: 2, color: AppColors.background),
                  _buildDetailRow('Tác giả', author),
                  Divider(thickness: 2, color: AppColors.background),
                  _buildDetailRow('Chi tiết', 'Detail bla bla'),
                  Divider(thickness: 2, color: AppColors.background),
                  _buildDetailRow('Chi tiết', 'Detail bla bla'),
                  Divider(thickness: 2, color: AppColors.background),
                  _buildDetailRow('Chi tiết', 'Detail bla bla'),
                  Divider(thickness: 2, color: AppColors.background),
                ],
              ),
            ),
            Divider(thickness: 10, color: AppColors.background),
            // Description Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mô tả sách',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla',
                    style: TextStyle(fontSize: 14, color: AppColors.bodyText),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Xem thêm',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: AppColors.background,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SectionHeader(title: 'Khuyên dùng', color: Colors.blue),
                  const ListBooks(itemCount: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: MyButton(
                text: 'Thêm vào kệ',
                onPressed: () {},
                isReversedColor: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MyButton(text: 'Mượn ngay', onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.bodyText),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: AppColors.bodyText),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
