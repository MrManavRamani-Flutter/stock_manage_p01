import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.white),
      actions: [
        ElevatedButton.icon(
          onPressed: onButtonPressed,
          icon: const Icon(Icons.add, color: AppColors.primaryColor),
          label: Text(
            buttonText,
            style: const TextStyle(color: AppColors.primaryColor),
          ),
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromWidth(100),
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.05);
}
