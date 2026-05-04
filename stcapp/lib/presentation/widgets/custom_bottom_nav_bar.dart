import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGrey,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 1 ? Icons.map : Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppColors.white),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3 ? Icons.favorite : Icons.favorite_border,
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 4 ? Icons.person : Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
