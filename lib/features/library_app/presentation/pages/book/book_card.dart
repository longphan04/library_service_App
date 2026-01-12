import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import 'detail_page.dart';

class BookCard extends StatefulWidget {
  final String title;
  final String author;
  final String category;
  final int availableCount;
  final bool? isCartPage;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.category,
    required this.availableCount,
    this.isCartPage = false,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isChecked = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              title: widget.title,
              author: widget.author,
              category: widget.category,
              availableCount: widget.availableCount,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              flex: widget.isCartPage == true ? 5 : 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryButton,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
            // Info section
            Expanded(
              flex: widget.isCartPage == true ? 4 : 1,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Author
                    Text(
                      widget.author,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Category chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryButton,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        widget.category,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.buttonPrimaryText,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (widget.isCartPage == false) Spacer(),
                    // Available count
                    Align(
                      alignment: widget.isCartPage == false
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(
                        'Còn ${widget.availableCount} cuốn',
                        style: TextStyle(
                          fontSize: 14,
                          color: (widget.availableCount > 0)
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                    if (widget.isCartPage == true) ...[
                      Spacer(),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          checkColor: AppColors.sectionBackground,
                          activeColor: AppColors.primaryButton,

                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: BorderSide(
                            color: AppColors.primaryButton,
                            width: 1,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
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
