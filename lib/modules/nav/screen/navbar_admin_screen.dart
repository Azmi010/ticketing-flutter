import 'package:flutter/material.dart';
import 'package:ticketing_flutter/core/constants/app_color.dart';
import 'package:ticketing_flutter/modules/admin/event/screen/event_admin_screen.dart';
import 'package:ticketing_flutter/modules/admin/home/screen/home_admin_screen.dart';
import 'package:ticketing_flutter/modules/admin/order/screen/order_admin_screen.dart';
import 'package:ticketing_flutter/modules/admin/profile/screen/profile_admin_screen.dart';

class NavbarAdminScreen extends StatefulWidget {
  const NavbarAdminScreen({super.key});

  @override
  State<NavbarAdminScreen> createState() => _NavbarAdminScreenState();
}

class _NavbarAdminScreenState extends State<NavbarAdminScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeAdminScreen(),
    const EventAdminScreen(),
    const OrderAdminScreen(),
    const ProfileAdminScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num_outlined),
            label: "Events",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}