import 'package:dartz/dartz.dart';
import '../../core/utils/exception_handler.dart';
import '../../core/utils/geocode_helper.dart';
import '../datasources/places_data_source.dart';
import '../models/place_model.dart';
import '../models/places_response_model.dart';

class PlacesFetchResult {
  final List<PlaceModel> places;
  final bool isFromCache;

  const PlacesFetchResult({required this.places, required this.isFromCache});
}

abstract class PlacesRepository {
  Future<Either<AppException, PlacesFetchResult>> getPlaces(String location);
}

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesDataSource remoteDataSource;

  PlacesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<AppException, PlacesFetchResult>> getPlaces(
    String location,
  ) async {
    List<PlaceModel> mapResponseToPlaces(PlacesResponseModel responseModel) {
      final locationCoordinates = GeocodeHelper.getCoordinates(location);

      return responseModel.destinations.map((destination) {
        final placeCoordinates =
            GeocodeHelper.getCoordinates(destination.title) ??
            locationCoordinates;

        return PlaceModel(
          title: destination.title,
          location: location,
          description: destination.description,
          thumbnailUrl: destination.thumbnail,
          latitude: placeCoordinates?.latitude,
          longitude: placeCoordinates?.longitude,
        );
      }).toList();
    }

    try {
      final response = await remoteDataSource.getPlaces(location);
      final places = mapResponseToPlaces(response);
      return Right(PlacesFetchResult(places: places, isFromCache: false));
    } catch (_) {
      try {
        final cachedResponse = await remoteDataSource.getCachedPlaces(location);
        final cachedPlaces = mapResponseToPlaces(cachedResponse);
        return Right(
          PlacesFetchResult(places: cachedPlaces, isFromCache: true),
        );
      } catch (_) {
        return Left(
          AppException(
            message:
                'Unable to fetch places and no cached data is available for $location.',
          ),
        );
      }
    }
  }
}
