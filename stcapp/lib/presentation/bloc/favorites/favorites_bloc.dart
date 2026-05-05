import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/favorites_repository.dart';
import '../../../core/utils/exception_handler.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository repository;

  FavoritesBloc({required this.repository}) : super(const FavoritesInitial()) {
    on<GetFavoritesEvent>(_onGetFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }

  Future<void> _onGetFavorites(
    GetFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());

    try {
      final favorites = await repository.getAllFavorites();

      if (favorites.isEmpty) {
        emit(const FavoritesEmpty(message: 'No favorite places yet'));
      } else {
        emit(FavoritesLoaded(favorites: favorites));
      }
    } catch (e) {
      emit(
        FavoritesError(
          message: 'Failed to load favorites',
          exception: AppException(message: e.toString()),
        ),
      );
    }
  }

  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      // Reload and emit updated favorites list
      final favorites = await repository.getAllFavorites();
      if (favorites.isEmpty) {
        emit(const FavoritesEmpty(message: 'No favorite places yet'));
      } else {
        emit(FavoritesLoaded(favorites: favorites));
      }
    } catch (e) {
      emit(
        FavoritesError(
          message: 'Failed to add favorite',
          exception: AppException(message: e.toString()),
        ),
      );
    }
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await repository.removeFavorite(event.placeTitle);
      // Reload and emit updated favorites list
      final favorites = await repository.getAllFavorites();
      if (favorites.isEmpty) {
        emit(const FavoritesEmpty(message: 'No favorite places yet'));
      } else {
        emit(FavoritesLoaded(favorites: favorites));
      }
    } catch (e) {
      emit(
        FavoritesError(
          message: 'Failed to remove favorite',
          exception: AppException(message: e.toString()),
        ),
      );
    }
  }
}
