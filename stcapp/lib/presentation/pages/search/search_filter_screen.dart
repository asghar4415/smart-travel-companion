import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/search_filter.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../bloc/theme/theme_state.dart';

class SearchFilterScreen extends StatefulWidget {
  final SearchFilter initialFilter;
  final String currentLocation;

  const SearchFilterScreen({
    Key? key,
    required this.initialFilter,
    required this.currentLocation,
  }) : super(key: key);

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  late TextEditingController searchController;
  late SearchFilter currentFilter;

  @override
  void initState() {
    super.initState();
    currentFilter = widget.initialFilter;
    searchController = TextEditingController(text: currentFilter.searchQuery);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _updateFilter(SearchFilter newFilter) {
    setState(() {
      currentFilter = newFilter;
    });
  }

  void _clearAllFilters() {
    setState(() {
      currentFilter = const SearchFilter();
      searchController.clear();
    });
  }

  void _applyFilters() {
    Navigator.pop(context, currentFilter);
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
        final hintColor = isDarkMode
            ? AppColors.darkTextTertiary
            : AppColors.textGrey;
        final dividerColor = isDarkMode
            ? AppColors.darkDivider
            : AppColors.divider;
        final surfaceColor = isDarkMode
            ? AppColors.darkSurfaceLight
            : AppColors.white;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: textColor, // Updated
                          size: 24,
                        ),
                      ),
                      Text(
                        widget.currentLocation,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor, // Updated
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close,
                          color: textColor, // Updated
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: dividerColor, height: 1), // Updated
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Filters Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Filters',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: textColor, // Updated
                                ),
                              ),
                              GestureDetector(
                                onTap: _clearAllFilters,
                                child: Text(
                                  'Clear All',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Search box
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  surfaceColor, // Updated (Added background fill)
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: dividerColor, // Updated
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                _updateFilter(
                                  currentFilter.copyWith(searchQuery: value),
                                );
                              },
                              decoration: InputDecoration(
                                hintText: 'Search places...',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: hintColor, // Updated
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: hintColor, // Updated
                                ),
                              ),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: textColor, // Updated
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Show
                          Text(
                            'Show',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor, // Updated
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildFilterChip(
                                  label: 'All',
                                  isSelected:
                                      currentFilter.showFilter ==
                                      ShowFilter.all,
                                  isDarkMode: isDarkMode, // Added param
                                  onTap: () {
                                    _updateFilter(
                                      currentFilter.copyWith(
                                        showFilter: ShowFilter.all,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildFilterChip(
                                  label: 'Favorites',
                                  isSelected:
                                      currentFilter.showFilter ==
                                      ShowFilter.favorites,
                                  isDarkMode: isDarkMode, // Added param
                                  onTap: () {
                                    _updateFilter(
                                      currentFilter.copyWith(
                                        showFilter: ShowFilter.favorites,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Region
                          Text(
                            'Region',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor, // Updated
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDropdown(
                            value: currentFilter.selectedRegions.isEmpty
                                ? 'All Regions'
                                : currentFilter.selectedRegions[0],
                            isDarkMode: isDarkMode, // Added param
                            onChanged: (value) {
                              if (value == 'All Regions') {
                                _updateFilter(
                                  currentFilter.copyWith(selectedRegions: []),
                                );
                              } else {
                                _updateFilter(
                                  currentFilter.copyWith(
                                    selectedRegions: [value],
                                  ),
                                );
                              }
                            },
                            items: ['All Regions', ...AppConstants.locations],
                            labels: ['All Regions', ...AppConstants.locations],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),

                // Apply Filters Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Updated to accept `isDarkMode`
  Widget _buildDropdown({
    required String value,
    required Function(String) onChanged,
    required List<String> items,
    required List<String> labels,
    required bool isDarkMode,
  }) {
    final dividerColor = isDarkMode ? AppColors.darkDivider : AppColors.divider;
    final surfaceColor = isDarkMode
        ? AppColors.darkSurfaceLight
        : AppColors.white;
    final textColor = isDarkMode
        ? AppColors.darkTextPrimary
        : AppColors.textDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: surfaceColor, // Added background color
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: dividerColor, width: 1), // Updated
      ),
      child: DropdownButton<String>(
        value: items.contains(value) ? value : items[0],
        dropdownColor: surfaceColor, // Ensures the dropdown menu itself is dark
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        isExpanded: true,
        underline: const SizedBox(),
        items: List.generate(
          items.length,
          (index) => DropdownMenuItem<String>(
            value: items[index],
            child: Text(
              labels[index],
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: textColor, // Updated
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Updated to accept `isDarkMode`
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    final surfaceColor = isDarkMode
        ? AppColors.darkSurfaceLight
        : AppColors.white;
    final dividerColor = isDarkMode ? AppColors.darkDivider : AppColors.divider;
    final unselectedTextColor = isDarkMode
        ? AppColors.darkTextPrimary
        : AppColors.textDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : surfaceColor, // Updated
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : dividerColor, // Updated
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : unselectedTextColor, // Updated
            ),
          ),
        ),
      ),
    );
  }
}
