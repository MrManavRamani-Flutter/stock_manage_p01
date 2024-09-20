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
              // Menu Icon

              // Page Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                label: const Text(
                  'Add Warehouse',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                ),
              ),
              // Action Button (e.g. "Add Warehouse")
            ],
          ),

          // Optional Search Bar (if needed like in your image)
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primaryColor,
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(color: AppColors.white),
                icon: Icon(Icons.search, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(185); // Adjust height based on needs
}

// import 'package:flutter/material.dart';
// import 'package:stock_manage/constants/app_colors.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final List<Widget>? actions;
//
//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.actions,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.primaryColor,
//       child: Column(
//         children: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.menu,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//     // return AppBar(
//     //   backgroundColor: AppColors.primaryColor,
//     //   elevation: 0,
//     //   title: Text(
//     //     title,
//     //     style: const TextStyle(
//     //       fontSize: 20,
//     //       fontWeight: FontWeight.bold,
//     //       color: Colors.white,
//     //     ),
//     //   ),
//     //   actions: actions,
//     //   iconTheme: const IconThemeData(color: Colors.white),
//     // );
//   }
//
//   // This sets the default height of the AppBar
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
