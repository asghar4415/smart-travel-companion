import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/place_card.dart';
import '../../widgets/search_bar.dart' as search_bar_widget;
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/sidebar.dart';
import '../../bloc/places/places_bloc.dart';
import '../../bloc/places/places_event.dart';
import '../../bloc/places/places_state.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../bloc/theme/theme_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../details/details_screen.dart';
import '../search/search_filter_screen.dart';
import '../favourites/favourites_screen.dart';
import '../../../domain/entities/search_filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  int _selectedFilterIndex = 0;
  TextEditingController searchController = TextEditingController();
  String currentLocation = AppConstants.locations[0];
  SearchFilter currentFilter = const SearchFilter();
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    // Load initial places
    context.read<PlacesBloc>().add(GetPlacesEvent(location: currentLocation));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onLocationChanged(int index) {
    setState(() {
      _selectedFilterIndex = index;
      currentLocation = AppConstants.locations[index];
    });
    context.read<PlacesBloc>().add(GetPlacesEvent(location: currentLocation));
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    // Handle navigation
    if (index == 1) {
      // Map - TODO: implement map screen
    } else if (index == 3) {
      // Favourites
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FavouritesScreen()),
      ).then((_) {
        // Reset to home when returning from favourites
        setState(() {
          _currentNavIndex = 0;
        });
      });
    } else if (index == 4) {
      // Profile - TODO: implement profile screen
    }
  }

  Future<void> _openSearchFilter() async {
    final result = await Navigator.push<SearchFilter>(
      context,
      MaterialPageRoute(
        builder: (context) => SearchFilterScreen(
          initialFilter: currentFilter,
          currentLocation: currentLocation,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        currentFilter = result;
        searchController.text = result.searchQuery;

        // Update location selector if a region filter is applied
        if (result.selectedRegions.isNotEmpty) {
          currentLocation = result.selectedRegions[0];
          _selectedFilterIndex = AppConstants.locations.indexOf(
            currentLocation,
          );
        }
      });

      // Apply filters
      context.read<PlacesBloc>().add(
        SearchAndFilterEvent(location: currentLocation, filter: result),
      );
    }
  }

  void _performRealTimeSearch(String query) {
    // Create a new filter with the search query
    final updatedFilter = currentFilter.copyWith(searchQuery: query);

    setState(() {
      currentFilter = updatedFilter;
    });

    // Trigger search with current filters
    context.read<PlacesBloc>().add(
      SearchAndFilterEvent(location: currentLocation, filter: updatedFilter),
    );
  }

  void _handleMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _handleSidebarHomeTap() {
    Navigator.of(context).pop(); // Close the sidebar
    // Already on home screen
  }

  void _handleSidebarFavouritesTap() {
    Navigator.of(context).pop(); // Close the sidebar
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FavouritesScreen()),
    );
  }

  void _handleSidebarMapTap() {
    Navigator.of(context).pop(); // Close the sidebar
    // TODO: Implement map functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Map feature coming soon')));
  }

  void _handleSidebarDownloadTap() {
    Navigator.of(context).pop(); // Close the sidebar
    // TODO: Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download feature coming soon')),
    );
  }

  void _handleSidebarSettingsTap() {
    Navigator.of(context).pop(); // Close the sidebar
    // TODO: Implement settings functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Settings coming soon')));
  }

  void _handleSidebarHelpSupportTap() {
    Navigator.of(context).pop(); // Close the sidebar
    // TODO: Implement help & support functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Help & Support coming soon')));
  }

  void _handleSidebarAboutUsTap() {
    Navigator.of(context).pop(); // Close the sidebar
    // TODO: Implement about us functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('About Us coming soon')));
  }

  void _handleDarkModeTap(bool value) {
    // Toggle dark mode via BLoC (handled in Sidebar, so this can stay empty or dispatch an event if needed)
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        // --- ADDED: Dynamic Colors based on Dark Mode ---
        final isDarkMode = themeState.isDarkMode;
        final iconColor = isDarkMode
            ? AppColors.darkTextPrimary
            : AppColors.textDark;
        final textColor = isDarkMode
            ? AppColors.darkTextPrimary
            : AppColors.textDark;
        final chipBgColor = isDarkMode
            ? AppColors.darkSurfaceLight
            : AppColors.white;
        final chipBorderColor = isDarkMode
            ? AppColors.darkDivider
            : AppColors.divider;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: Sidebar(
            onHomeTap: _handleSidebarHomeTap,
            onFavouritesTap: _handleSidebarFavouritesTap,
            onMapTap: _handleSidebarMapTap,
            onDownloadTap: _handleSidebarDownloadTap,
            onSettingsTap: _handleSidebarSettingsTap,
            onHelpSupportTap: _handleSidebarHelpSupportTap,
            onAboutUsTap: _handleSidebarAboutUsTap,
            onDarkModeTap: _handleDarkModeTap,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Header with Menu and Notification
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _handleMenuTap,
                            child: Icon(
                              Icons.menu,
                              size: 24,
                              color: iconColor, // Updated
                            ),
                          ),
                          Text(
                            'Explore Places',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color:
                                      textColor, // Updated to ensure visibility
                                ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle notifications
                            },
                            child: Icon(
                              Icons.notifications_outlined,
                              size: 24,
                              color: iconColor, // Updated
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Search Bar
                      search_bar_widget.SearchBar(
                        controller: searchController,
                        onFilterTap: _openSearchFilter,
                        onChanged: (value) {
                          _performRealTimeSearch(value);
                        },
                      ),
                      const SizedBox(height: 16),
                      // Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            AppConstants.locations.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(AppConstants.locations[index]),
                                selected: _selectedFilterIndex == index,
                                onSelected: (selected) {
                                  _onLocationChanged(index);
                                },
                                backgroundColor: chipBgColor, // Updated
                                selectedColor: Theme.of(context).primaryColor,
                                labelStyle: TextStyle(
                                  color: _selectedFilterIndex == index
                                      ? Colors.white
                                      : textColor, // Updated
                                  fontWeight: FontWeight.w500,
                                ),
                                side: BorderSide(
                                  color: _selectedFilterIndex == index
                                      ? Theme.of(context).primaryColor
                                      : chipBorderColor, // Updated
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Places List
                Expanded(
                  child: BlocBuilder<PlacesBloc, PlacesState>(
                    builder: (context, state) {
                      if (state is PlacesInitial || state is PlacesLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      } else if (state is PlacesLoaded) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            context.read<PlacesBloc>().add(
                              RefreshPlacesEvent(location: state.location),
                            );
                          },
                          color: AppColors.primary,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.places.length,
                            itemBuilder: (context, index) {
                              final place = state.places[index];
                              return PlaceCard(
                                place: place,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreen(place: place),
                                    ),
                                  );
                                },
                                onFavoriteTap: () {
                                  context.read<PlacesBloc>().add(
                                    ToggleFavoriteEvent(index: index),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      } else if (state is PlacesError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: AppColors.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Oops! Something went wrong',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: textColor, // Updated
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<PlacesBloc>().add(
                                      GetPlacesEvent(location: currentLocation),
                                    );
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (state is PlacesEmpty) {
                        return EmptyStateWidget(
                          title: 'No places found',
                          subtitle:
                              'Try adjusting your search or filter to find what you\'re looking for.',
                          onAction: () {
                            setState(() {
                              currentFilter = const SearchFilter();
                              searchController.clear();
                            });
                            context.read<PlacesBloc>().add(
                              GetPlacesEvent(location: currentLocation),
                            );
                          },
                          actionLabel: 'Clear Filters',
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
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
