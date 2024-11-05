import 'package:flutter/material.dart';
import 'package:stock_manage/widgets/bottom_navigation.dart';

import 'constants/app_colors.dart';

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
        textTheme: const TextTheme(
          bodySmall: TextStyle(fontSize: 9), // Small size for mobile
          bodyMedium: TextStyle(fontSize: 11), // Default size for mobile
          bodyLarge: TextStyle(fontSize: 12), // Large size for mobile
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primaryColor,
          secondary:
              AppColors.accentColor, // Replace accentColor with secondary
        ),
      ),
      darkTheme: ThemeData.dark(),
      // Dark theme
      home: const BottomNavigation(),
    );
  }
}
