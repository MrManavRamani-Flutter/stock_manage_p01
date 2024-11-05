import 'package:flutter/material.dart';
import 'package:stock_manage/views/client_views/purchase_views/purchase_products.dart';
import 'package:stock_manage/views/employee_views/employee_view.dart';
import 'package:stock_manage/views/home_views/dashboard.dart';
import 'package:stock_manage/widgets/custom_sidebar.dart';

import '../constants/app_colors.dart';
import '../views/client_views/clients_view.dart';
import '../views/warehouse_view/warehouses_view.dart';

class BottomNavigation extends StatefulWidget {
  final int index;
  const BottomNavigation({super.key, this.index = 2});

  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const ClientsView(),
    const WarehousesView(),
    const Dashboard(),
    const EmployeeView(),
    const PurchaseProduct(),
    // const UserProfile(),
  ];
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index; // Initialize _currentIndex from widget.index
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const Sidebar(),
        backgroundColor: AppColors.primaryColor,
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.gray,
          items: const [
            BottomNavigationBarItem(
              backgroundColor: AppColors.white,
              icon: Icon(Icons.person), // For Clients
              label: 'Clients',
            ),
            BottomNavigationBarItem(
              backgroundColor: AppColors.white,
              icon: Icon(Icons.store), // For Warehouses
              label: 'Warehouses',
            ),
            BottomNavigationBarItem(
              backgroundColor: AppColors.white,
              icon: Icon(Icons.dashboard), // For Dashboard
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              backgroundColor: AppColors.white,
              icon: Icon(Icons.group), // For Employees
              label: 'Employees',
            ),
            BottomNavigationBarItem(
              backgroundColor: AppColors.white,
              icon: Icon(Icons.receipt_long), // For Orders
              label: 'Orders', // New Order option
            ),

            // BottomNavigationBarItem(
            //   backgroundColor: AppColors.white,
            //   icon: Icon(Icons.perm_contact_cal_sharp),
            //   label: 'Profile',
            // ),
          ],
        ),
      ),
    );
  }
}
