import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_state.dart';

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
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        // --- ADDED: Dynamic Colors based on Dark Mode ---
        final isDarkMode = themeState.isDarkMode;

        final bgColor = isDarkMode
            ? AppColors.darkSurfaceLight
            : AppColors.white;
        final unselectedColor = isDarkMode
            ? AppColors.darkTextTertiary
            : AppColors.textGrey;
        // Make the shadow slightly darker in dark mode so it separates from the dark background
        final shadowColor = isDarkMode
            ? Colors.black.withOpacity(0.3)
            : Colors.black.withOpacity(0.1);

        return Container(
          decoration: BoxDecoration(
            color: bgColor, // Updated
            boxShadow: [
              BoxShadow(
                color: shadowColor, // Updated
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              type: BottomNavigationBarType.fixed,
              backgroundColor: bgColor, // Updated
              selectedItemColor: AppColors.primary,
              unselectedItemColor: unselectedColor, // Updated
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    currentIndex == 0 ? Icons.home : Icons.home_outlined,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    currentIndex == 1 ? Icons.map : Icons.map_outlined,
                  ),
                  label: 'Map',
                ),
                BottomNavigationBarItem(
                  icon: Transform.translate(
                    offset: const Offset(0, -20),
                    child: Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      // Keeping white here because it sits on top of the primary color
                      child: const Icon(Icons.add, color: AppColors.white),
                    ),
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
                  icon: Icon(
                    currentIndex == 4 ? Icons.person : Icons.person_outline,
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
