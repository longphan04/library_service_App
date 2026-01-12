import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.navBackground, elevation: 0),
    );
  }
}
