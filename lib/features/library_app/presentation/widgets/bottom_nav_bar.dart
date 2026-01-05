import 'package:flutter/material.dart';

/// Reusable bottom navigation bar widget
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavItem(Icons.home_outlined, 0),
          const SizedBox(width: 50),
          _buildNavItem(Icons.grid_view_outlined, 1),
          const SizedBox(width: 50),
          _buildNavItem(Icons.shopping_cart_outlined, 2),
          const SizedBox(width: 50),
          _buildNavItem(Icons.person_outline, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Icon(
        icon,
        size: 32,
        color: isSelected ? Colors.blue : Colors.grey[600],
      ),
    );
  }
}
