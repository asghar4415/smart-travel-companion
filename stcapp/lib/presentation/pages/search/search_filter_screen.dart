import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/search_filter.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
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
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textDark,
                      size: 24,
                    ),
                  ),
                  Text(
                    widget.currentLocation,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.textDark,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.divider, height: 1),

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
                              color: AppColors.textDark,
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
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.divider,
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
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.textGrey,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.textGrey,
                            ),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textDark,
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
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterChip(
                              label: 'All',
                              isSelected:
                                  currentFilter.showFilter == ShowFilter.all,
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
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: currentFilter.selectedRegions.isEmpty
                            ? 'All Regions'
                            : currentFilter.selectedRegions[0],
                        onChanged: (value) {
                          if (value == 'All Regions') {
                            _updateFilter(
                              currentFilter.copyWith(selectedRegions: []),
                            );
                          } else {
                            _updateFilter(
                              currentFilter.copyWith(selectedRegions: [value]),
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
  }

  Widget _buildDropdown({
    required String value,
    required Function(String) onChanged,
    required List<String> items,
    required List<String> labels,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: DropdownButton<String>(
        value: items.contains(value) ? value : items[0],
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
                color: AppColors.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}
