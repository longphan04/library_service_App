import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class NavigationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget page;

  const NavigationItem({
    super.key,
    required this.icon,
    required this.title,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus trước khi navigate để ẩn bàn phím
        FocusScope.of(context).unfocus();
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Row(
        children: [
          Icon(icon, color: AppColors.bodyText),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, color: AppColors.bodyText),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.bodyText),
        ],
      ),
    );
  }
}
