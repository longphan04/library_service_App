import 'package:flutter/material.dart';

class HotList extends StatefulWidget {
  const HotList({super.key});

  @override
  State<HotList> createState() => _HotListState();
}

class _HotListState extends State<HotList> {
  late PageController _pageController;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.4, initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
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
        itemCount: 10,
        itemBuilder: (context, index) {
          // Calculate scale based on distance from center
          double diff = (_currentPage - index).abs();
          double scale = 1.0 - (diff * 0.25).clamp(0.0, 0.25);

          // Size based on scale: 150 when far, 200 when centered
          double height = 150 + (scale - 0.75) * 250;

          return Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: height,
              width: height * 0.7,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Icon(Icons.book, size: 64, color: Colors.grey[600]),
              ),
            ),
          );
        },
      ),
    );
  }
}
