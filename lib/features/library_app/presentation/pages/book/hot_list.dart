import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class HotList extends StatefulWidget {
  const HotList({super.key});

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
    return SizedBox(
      height: 240,
      child: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          // Loop through items 0-9 infinitely
          int actualIndex = index % 10;

          // Calculate scale based on distance from center
          double diff = (_currentPage - index).abs();
          double scale = 1.0 - (diff * 0.25).clamp(0.0, 0.25);

          // Size based on scale: 150 when far, 200 when centered
          double height = 150 + (scale - 0.75) * 250;

          return Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: height,
              width: height * 0.7,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: AppColors.primaryButton,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  'Top ${actualIndex + 1}',
                  style: TextStyle(
                    color: AppColors.buttonPrimaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
