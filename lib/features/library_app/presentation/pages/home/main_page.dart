import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: SearchAppBar(
        onSearchChanged: (query) {
          // TODO: Implement search
        },
        onMessagesPressed: () {
          // TODO: Navigate to messages
        },
        showBackButton: false, // Always show logo on main pages
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
