import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'widgets/bottom_navigation.dart';

void main() {
  runApp(const StockManagementApp());
}

class StockManagementApp extends StatelessWidget {
  const StockManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Management App',
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
        ),
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primaryColor,
          secondary:
              AppColors.accentColor, // Replace accentColor with secondary
        ),
      ),
      home: const BottomNavigation(),
    );
  }
}
