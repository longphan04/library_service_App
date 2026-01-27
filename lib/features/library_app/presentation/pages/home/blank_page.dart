import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.navBackground, elevation: 0),
      body: const Center(
        child: Text(
          'Sẽ phát triển trong tương lai',
          style: TextStyle(fontSize: 16, color: AppColors.subText),
        ),
      ),
    );
  }
}
