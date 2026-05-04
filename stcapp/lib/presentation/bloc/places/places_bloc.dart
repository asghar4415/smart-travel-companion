import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/places_repository_impl.dart';
import '../../../data/models/place_model.dart';
import '../../../domain/entities/search_filter.dart';
import 'places_event.dart';
import 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final PlacesRepository repository;

  PlacesBloc({required this.repository}) : super(const PlacesInitial()) {
    on<GetPlacesEvent>(_onGetPlaces);
    on<RefreshPlacesEvent>(_onRefreshPlaces);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<ClearPlacesEvent>(_onClearPlaces);
    on<SearchAndFilterEvent>(_onSearchAndFilter);
  }

  Future<void> _onGetPlaces(
    GetPlacesEvent event,
    Emitter<PlacesState> emit,
  ) async {
    emit(const PlacesLoading());

    final result = await repository.getPlaces(event.location);

    result.fold(
      (exception) =>
          emit(PlacesError(message: exception.message, exception: exception)),
      (places) {
        if (places.isEmpty) {
          emit(
            PlacesEmpty(message: 'No destinations found for ${event.location}'),
          );
        } else {
          emit(PlacesLoaded(places: places, location: event.location));
        }
      },
    );
  }

  Future<void> _onRefreshPlaces(
    RefreshPlacesEvent event,
    Emitter<PlacesState> emit,
  ) async {
    add(GetPlacesEvent(location: event.location));
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<PlacesState> emit,
  ) async {
    if (state is PlacesLoaded) {
      final currentState = state as PlacesLoaded;
      final updatedPlaces = List<PlaceModel>.from(currentState.places);

      if (event.index < updatedPlaces.length) {
        updatedPlaces[event.index] = updatedPlaces[event.index].copyWith(
          isFavorite: !updatedPlaces[event.index].isFavorite,
        );

        emit(
          PlacesLoaded(places: updatedPlaces, location: currentState.location),
        );
      }
    }
  }

  Future<void> _onClearPlaces(
    ClearPlacesEvent event,
    Emitter<PlacesState> emit,
  ) async {
    emit(const PlacesInitial());
  }

  Future<void> _onSearchAndFilter(
    SearchAndFilterEvent event,
    Emitter<PlacesState> emit,
  ) async {
    emit(const PlacesLoading());

    final result = await repository.getPlaces(event.location);

    result.fold(
      (exception) =>
          emit(PlacesError(message: exception.message, exception: exception)),
      (allPlaces) {
        // Apply filters
        List<PlaceModel> filteredPlaces = allPlaces;

        // Filter by search query
        if (event.filter.searchQuery.isNotEmpty) {
          filteredPlaces = filteredPlaces
              .where(
                (place) =>
                    place.title.toLowerCase().contains(
                      event.filter.searchQuery.toLowerCase(),
                    ) ||
                    place.description.toLowerCase().contains(
                      event.filter.searchQuery.toLowerCase(),
                    ),
              )
              .toList();
        }

        // Filter by show filter (favorites)
        if (event.filter.showFilter == ShowFilter.favorites) {
          filteredPlaces = filteredPlaces
              .where((place) => place.isFavorite)
              .toList();
        }

        // Filter by region
        if (event.filter.selectedRegions.isNotEmpty) {
          filteredPlaces = filteredPlaces
              .where(
                (place) =>
                    event.filter.selectedRegions.contains(place.location),
              )
              .toList();
        }

        // Sort results
        switch (event.filter.sortBy) {
          case SortBy.priceHighToLow:
            filteredPlaces.sort(
              (a, b) => (b.extractedFlightPrice ?? 0).compareTo(
                a.extractedFlightPrice ?? 0,
              ),
            );
            break;
          case SortBy.priceLowToHigh:
            filteredPlaces.sort(
              (a, b) => (a.extractedFlightPrice ?? 0).compareTo(
                b.extractedFlightPrice ?? 0,
              ),
            );
            break;
          case SortBy.recommended:
          case SortBy.rating:
            // Keep original order (recommended)
            break;
        }

        if (filteredPlaces.isEmpty) {
          emit(
            const PlacesEmpty(message: 'No places found matching your filters'),
          );
        } else {
          emit(PlacesLoaded(places: filteredPlaces, location: event.location));
        }
      },
    );
  }
}
