import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/place_card.dart';
import '../../widgets/search_bar.dart' as search_bar_widget;
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/empty_state_widget.dart';
import '../../bloc/places/places_bloc.dart';
import '../../bloc/places/places_event.dart';
import '../../bloc/places/places_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../details/details_screen.dart';
import '../search/search_filter_screen.dart';
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

  @override
  void initState() {
    super.initState();
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
    // Handle navigation for other pages later
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                        onTap: () {
                          // Open drawer or menu
                        },
                        child: const Icon(
                          Icons.menu,
                          size: 24,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Explore Places',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle notifications
                        },
                        child: const Icon(
                          Icons.notifications_outlined,
                          size: 24,
                          color: AppColors.textDark,
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
                            backgroundColor: AppColors.background,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: _selectedFilterIndex == index
                                  ? AppColors.white
                                  : AppColors.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                            side: BorderSide(
                              color: _selectedFilterIndex == index
                                  ? AppColors.primary
                                  : AppColors.divider,
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
                              style: Theme.of(context).textTheme.headlineSmall,
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
  }
}
