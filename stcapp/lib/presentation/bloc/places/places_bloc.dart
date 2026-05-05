import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/places_repository_impl.dart';
import '../../../data/repositories/favorites_repository.dart';
import '../../../data/models/place_model.dart';
import '../../../domain/entities/search_filter.dart';
import 'places_event.dart';
import 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final PlacesRepository repository;
  final FavoritesRepository favoritesRepository;

  PlacesBloc({required this.repository, required this.favoritesRepository})
    : super(const PlacesInitial()) {
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

    if (result.isRight()) {
      final places = result.fold((_) => <PlaceModel>[], (p) => p);

      if (places.isEmpty) {
        emit(
          PlacesEmpty(message: 'No destinations found for ${event.location}'),
        );
      } else {
        // Load favorite status for each place
        final placesWithFavStatus = <PlaceModel>[];
        for (final place in places) {
          try {
            final isFav = await favoritesRepository.isFavorite(place.title);
            placesWithFavStatus.add(place.copyWith(isFavorite: isFav));
          } catch (_) {
            // If checking favorite fails, just add place as-is
            placesWithFavStatus.add(place);
          }
        }

        emit(
          PlacesLoaded(places: placesWithFavStatus, location: event.location),
        );
      }
    } else {
      final exception = result.fold((e) => e, (_) => null);
      if (exception != null) {
        emit(PlacesError(message: exception.message, exception: exception));
      }
    }
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
        try {
          final place = updatedPlaces[event.index];
          final newFavStatus = !place.isFavorite;

          // Update local storage
          if (newFavStatus) {
            await favoritesRepository.saveFavorite(place);
          } else {
            await favoritesRepository.removeFavorite(place.title);
          }

          updatedPlaces[event.index] = place.copyWith(isFavorite: newFavStatus);

          emit(
            PlacesLoaded(
              places: updatedPlaces,
              location: currentState.location,
            ),
          );
        } catch (e) {
          // Silently fail on favorite toggle
        }
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

    var allPlaces = <PlaceModel>[];

    // If region filter is selected, fetch from those regions
    if (event.filter.selectedRegions.isNotEmpty) {
      for (final region in event.filter.selectedRegions) {
        final result = await repository.getPlaces(region);
        if (result.isRight()) {
          final places = result.fold((_) => <PlaceModel>[], (p) => p);
          allPlaces.addAll(places);
        }
      }
    } else {
      // Otherwise, fetch from the current location
      final result = await repository.getPlaces(event.location);
      if (result.isRight()) {
        allPlaces = result.fold((_) => <PlaceModel>[], (p) => p);
      } else {
        final exception = result.fold(
          (exception) => exception,
          (places) => null,
        );
        emit(
          PlacesError(
            message: exception?.message ?? 'Unknown error',
            exception: exception!,
          ),
        );
        return;
      }
    }

    // Load favorite status for each place
    final placesWithFavStatus = <PlaceModel>[];
    for (final place in allPlaces) {
      try {
        final isFav = await favoritesRepository.isFavorite(place.title);
        placesWithFavStatus.add(place.copyWith(isFavorite: isFav));
      } catch (_) {
        placesWithFavStatus.add(place);
      }
    }
    allPlaces = placesWithFavStatus;

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
      emit(const PlacesEmpty(message: 'No places found matching your filters'));
    } else {
      emit(
        PlacesLoaded(
          places: filteredPlaces,
          location: event.filter.selectedRegions.isNotEmpty
              ? event.filter.selectedRegions.join(', ')
              : event.location,
        ),
      );
    }
  }
}
