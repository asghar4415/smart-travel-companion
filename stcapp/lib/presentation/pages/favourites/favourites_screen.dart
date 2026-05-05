import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/place_card.dart';
import '../details/details_screen.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/favorites/favorites_state.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../bloc/theme/theme_state.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  int _currentNavIndex = 1;

  @override
  void initState() {
    super.initState();
    // Load favorites when screen opens
    context.read<FavoritesBloc>().add(const GetFavoritesEvent());
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    // Handle navigation
    if (index == 0) {
      // Home - pop back to home
      Navigator.pop(context);
    } else if (index == 1) {
      // Favorites - already on this screen
    } else if (index == 2) {
      // Add - TODO: implement add screen
    } else if (index == 3) {
      // Favorites - already on this screen
    } else if (index == 4) {
      // Profile - TODO: implement profile screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        // --- ADDED: Dynamic Colors based on Dark Mode ---
        final isDarkMode = themeState.isDarkMode;
        final textColor = isDarkMode
            ? AppColors.darkTextPrimary
            : AppColors.textDark;
        final subtitleColor = isDarkMode
            ? AppColors.darkTextSecondary
            : AppColors.textLight;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Favourites'),
            elevation: 0,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          ),
          body: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state is FavoritesLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  itemCount: state.favorites.length,
                  itemBuilder: (context, index) {
                    final place = state.favorites[index];
                    return PlaceCard(
                      place: place,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(place: place),
                          ),
                        );
                      },
                      onFavoriteTap: () {
                        context.read<FavoritesBloc>().add(
                          RemoveFavoriteEvent(placeTitle: place.title),
                        );
                      },
                    );
                  },
                );
              } else if (state is FavoritesEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_outline,
                        size: 80,
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Favourites Yet',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: textColor, // Updated
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start adding your favorite places!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: subtitleColor, // Updated
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is FavoritesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 80,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error Loading Favourites',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: textColor, // Updated
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: subtitleColor, // Updated
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentNavIndex,
            onTap: _onBottomNavTap,
          ),
        );
      },
    );
  }
}
