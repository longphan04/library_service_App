import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/book.dart';
import 'detail_page.dart';

class HotList extends StatefulWidget {
  final List<Book> books;

  const HotList({super.key, required this.books});

  @override
  State<HotList> createState() => _HotListState();
}

class _HotListState extends State<HotList> {
  late PageController _pageController;
  double _currentPage = 10000;

  @override
  void initState() {
    super.initState();
    // Start at a large number so user can scroll both directions
    _pageController = PageController(viewportFraction: 0.4, initialPage: 10000);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 10000;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.books.isEmpty) {
      return SizedBox(
        height: 240,
        child: Center(
          child: Text(
            'Chưa có sách phổ biến',
            style: TextStyle(color: AppColors.subText),
          ),
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          // Loop through items infinitely
          int actualIndex = index % widget.books.length;
          final book = widget.books[actualIndex];

          // Calculate scale based on distance from center
          double diff = (_currentPage - index).abs();
          double scale = 1.0 - (diff * 0.25).clamp(0.0, 0.25);

          // Size based on scale: 150 when far, 200 when centered
          double height = 150 + (scale - 0.75) * 250;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    bookId: book.bookId,
                    initialCoverUrl: book.coverUrl ?? '',
                  ),
                ),
              );
            },
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                height: height,
                width: height * 0.7,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Stack(
                  children: [
                    // Book cover image
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            book.coverUrl != null && book.coverUrl!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: book.coverUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.primaryButton,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.buttonPrimaryText,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.primaryButton,
                                  child: Center(
                                    child: Icon(
                                      Icons.book,
                                      color: AppColors.buttonPrimaryText,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                color: AppColors.primaryButton,
                                child: Center(
                                  child: Icon(
                                    Icons.book,
                                    color: AppColors.buttonPrimaryText,
                                    size: 40,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    // Top badge at top-right corner
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Top ${actualIndex + 1}',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
