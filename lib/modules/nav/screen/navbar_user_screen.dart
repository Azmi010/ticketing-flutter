import 'package:flutter/material.dart';
import 'package:ticketing_flutter/core/constants/app_color.dart';
import 'package:ticketing_flutter/modules/explore/screen/explore_screen.dart';
import 'package:ticketing_flutter/modules/home/screen/home_screen.dart';
import 'package:ticketing_flutter/modules/myticket/screen/myticket_screen.dart';
import 'package:ticketing_flutter/modules/profile/screen/profile_screen.dart';

class NavbarUserScreen extends StatefulWidget {
  const NavbarUserScreen({super.key});

  @override
  State<NavbarUserScreen> createState() => _NavbarUserScreenState();
}

class _NavbarUserScreenState extends State<NavbarUserScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const MyTicketScreen(),
    const ProfileScreen(),
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
            icon: Icon(Icons.explore_outlined),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num_outlined),
            label: "My Tickets",
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