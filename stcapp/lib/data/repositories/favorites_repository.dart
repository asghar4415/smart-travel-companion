import '../models/place_model.dart';
import '../datasources/favorites_local_datasource.dart';

abstract class FavoritesRepository {
  Future<void> saveFavorite(PlaceModel place);
  Future<void> removeFavorite(String placeTitle);
  Future<List<PlaceModel>> getAllFavorites();
  Future<bool> isFavorite(String placeTitle);
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveFavorite(PlaceModel place) async {
    return await localDataSource.saveFavorite(place.copyWith(isFavorite: true));
  }

  @override
  Future<void> removeFavorite(String placeTitle) async {
    return await localDataSource.removeFavorite(placeTitle);
  }

  @override
  Future<List<PlaceModel>> getAllFavorites() async {
    return await localDataSource.getAllFavorites();
  }

  @override
  Future<bool> isFavorite(String placeTitle) async {
    return await localDataSource.isFavorite(placeTitle);
  }
}
