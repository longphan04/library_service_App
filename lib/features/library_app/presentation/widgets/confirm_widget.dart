import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ConfirmWidget extends StatelessWidget {
  final String message;
  final VoidCallback onConfirm;
  const ConfirmWidget({
    super.key,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      content: Text(
        message,
        style: TextStyle(
          color: AppColors.titleText,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Hủy',
            style: TextStyle(color: AppColors.buttonSecondaryText),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              AppColors.primaryButton,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Pop dialog trước
            onConfirm();
          },
          child: const Text(
            'Xác nhận',
            style: TextStyle(color: AppColors.buttonPrimaryText),
          ),
        ),
      ],
    );
  }
}
