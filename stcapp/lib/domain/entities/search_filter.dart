import 'package:equatable/equatable.dart';

enum SortBy { recommended, priceHighToLow, priceLowToHigh, rating }

enum ShowFilter { all, favorites }

class SearchFilter extends Equatable {
  final String searchQuery;
  final SortBy sortBy;
  final ShowFilter showFilter;
  final List<String> selectedRegions;

  const SearchFilter({
    this.searchQuery = '',
    this.sortBy = SortBy.recommended,
    this.showFilter = ShowFilter.all,
    this.selectedRegions = const [],
  });

  SearchFilter copyWith({
    String? searchQuery,
    SortBy? sortBy,
    ShowFilter? showFilter,
    List<String>? selectedRegions,
  }) {
    return SearchFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      showFilter: showFilter ?? this.showFilter,
      selectedRegions: selectedRegions ?? this.selectedRegions,
    );
  }

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      sortBy != SortBy.recommended ||
      showFilter != ShowFilter.all ||
      selectedRegions.isNotEmpty;

  @override
  List<Object?> get props => [searchQuery, sortBy, showFilter, selectedRegions];
}
