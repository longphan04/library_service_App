import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import 'home_page.dart';
import 'categories_page.dart';
import 'cart_page.dart';
import 'user_page.dart';
import '../../widgets/search_app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CategoriesPage(),
    const CartPage(),
    const UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final currentFocus = FocusScope.of(context);
        if (currentFocus.hasFocus) {
          currentFocus.unfocus();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: GestureDetector(
        // Unfocus when tapping outside
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: SearchAppBar(
            onSearchChanged: (query) {},
            showBackButton: false,
          ),
          body: IndexedStack(index: _currentIndex, children: _pages),
          bottomNavigationBar: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              FocusScope.of(context).unfocus();
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
