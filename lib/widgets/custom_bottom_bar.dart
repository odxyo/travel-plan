import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_plan/screens/pages/homePage.dart';
import 'package:travel_plan/screens/pages/like_screen.dart';
import 'package:travel_plan/screens/pages/seach_screen.dart';
import 'package:travel_plan/screens/pages/setting_screen.dart';
import 'package:travel_plan/screens/pages/trips_screen.dart';
import 'package:travel_plan/services/btmbar/nav_service.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          return IndexedStack(
            index: navigationProvider.currentIndex,
            children: [
              HomeScreen(),
              SearchPage(),
              LikePage(),
              TripsScreen(),
              SettingScreen(),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: PaletteTheme.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: PaletteTheme.hover.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home,
                  label: 'Home',
                  isActive: navigationProvider.currentIndex == 0,
                  onTap: () => navigationProvider.setIndex(0),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.search,
                  label: 'Search',
                  isActive: navigationProvider.currentIndex == 1,
                  onTap: () => navigationProvider.setIndex(1),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.favorite,
                  label: 'Like',
                  isActive: navigationProvider.currentIndex == 2,
                  onTap: () => navigationProvider.setIndex(2),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.flight_takeoff,
                  label: 'Trip',
                  isActive: navigationProvider.currentIndex == 3,
                  onTap: () => navigationProvider.setIndex(3),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.person,
                  label: 'Profile',
                  isActive: navigationProvider.currentIndex == 4,
                  onTap: () => navigationProvider.setIndex(4),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: PaletteTheme.yellow,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              )
            : null,
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? PaletteTheme.black : PaletteTheme.title,
              size: 30,
            ),
            if (isActive)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  label,
                  style: TextStyle(
                    color: PaletteTheme.textDesc,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
