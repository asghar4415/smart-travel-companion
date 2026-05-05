import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_event.dart';
import '../bloc/theme/theme_state.dart';

class Sidebar extends StatefulWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onFavouritesTap;
  final VoidCallback onMapTap;
  final VoidCallback onDownloadTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onHelpSupportTap;
  final VoidCallback onAboutUsTap;
  final ValueChanged<bool> onDarkModeTap;

  const Sidebar({
    Key? key,
    required this.onHomeTap,
    required this.onFavouritesTap,
    required this.onMapTap,
    required this.onDownloadTap,
    required this.onSettingsTap,
    required this.onHelpSupportTap,
    required this.onAboutUsTap,
    required this.onDarkModeTap,
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDarkMode = themeState.isDarkMode;
        final backgroundColor = isDarkMode
            ? AppColors.darkBackground
            : AppColors.background;
        final containerColor = isDarkMode
            ? AppColors.darkSurfaceLight
            : AppColors.primary;
        final textColor = isDarkMode
            ? AppColors.darkTextPrimary
            : AppColors.white;

        return Drawer(
          elevation: 0,
          child: Container(
            color: backgroundColor,
            child: SafeArea(
              child: Column(
                children: [
                  // User Profile Section
                  Container(
                    color: containerColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 18.0,
                    ),
                    child: Row(
                      children: [
                        // User Avatar
                        Container(
                          height: 100,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white.withOpacity(0.2),
                            border: Border.all(
                              color: AppColors.white,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: ClipOval(
                              child: Image.asset(
                                'images/character-img.webp',
                                fit: BoxFit.cover,
                                height: 65,
                                width: 65,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // User Name and Email
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Asghar Ali',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: textColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'asghar@example.com',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: textColor.withOpacity(0.8),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Menu Options
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            // Menu Items
                            _buildMenuItem(
                              context,
                              icon: Icons.home_outlined,
                              label: 'Home',
                              onTap: widget.onHomeTap,
                            ),
                            _buildMenuItem(
                              context,
                              icon: Icons.map_outlined,
                              label: 'Map',
                              onTap: widget.onMapTap,
                            ),
                            _buildMenuItem(
                              context,
                              icon: Icons.favorite_outline,
                              label: 'Favourites',
                              onTap: widget.onFavouritesTap,
                            ),
                            _buildMenuItem(
                              context,
                              icon: Icons.download_outlined,
                              label: 'Download',
                              onTap: widget.onDownloadTap,
                            ),
                            _buildMenuItem(
                              context,
                              icon: Icons.settings_outlined,
                              label: 'Settings',
                              onTap: widget.onSettingsTap,
                            ),
                            _buildMenuItem(
                              context,
                              icon: Icons.help_outline,
                              label: 'Help & Support',
                              onTap: widget.onHelpSupportTap,
                            ),
                            _buildMenuItem(
                              context,
                              icon: Icons.info_outline,
                              label: 'About Us',
                              onTap: widget.onAboutUsTap,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Dark Mode Toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      children: [
                        Divider(
                          color: isDarkMode
                              ? AppColors.darkDivider
                              : AppColors.divider,
                          thickness: 1,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isDarkMode
                                      ? Icons.dark_mode
                                      : Icons.light_mode,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Dark Mode',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            Switch(
                              value: isDarkMode,
                              onChanged: (value) {
                                context.read<ThemeBloc>().add(
                                  const ToggleThemeEvent(),
                                );
                              },
                              activeColor: AppColors.primary,
                              inactiveTrackColor: isDarkMode
                                  ? AppColors.darkDivider
                                  : AppColors.divider,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDarkMode = themeState.isDarkMode;
        final iconColor = isDarkMode
            ? AppColors.darkTextSecondary
            : AppColors.textDark;
        final textColor = isDarkMode
            ? AppColors.darkTextSecondary
            : AppColors.textDark;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            leading: Icon(icon, color: iconColor, size: 22),
            title: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: textColor),
            ),
            onTap: onTap,
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        );
      },
    );
  }
}
