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
    return Container(
      color: AppColors.primaryColor, // Use the primary color for the background
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Page Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              ElevatedButton.icon(
                onPressed: onButtonPressed,
                icon: const Icon(
                  Icons.add,
                  color: AppColors.primaryColor,
                ),
                label: Text(
                  'Add $title',
                  style: const TextStyle(color: AppColors.primaryColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(135); // Adjust height based on needs
}
