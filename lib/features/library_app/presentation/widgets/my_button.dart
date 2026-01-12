import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isReversedColor;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isReversedColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isReversedColor
              ? AppColors.sectionBackground
              : AppColors.primaryButton,
          foregroundColor: isReversedColor
              ? AppColors.buttonSecondaryText
              : AppColors.buttonPrimaryText,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isReversedColor
                ? BorderSide(color: AppColors.primaryButton, width: 1)
                : BorderSide.none,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
