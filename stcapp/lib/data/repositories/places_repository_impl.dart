import 'package:dartz/dartz.dart';
import '../../core/utils/exception_handler.dart';
import '../../core/utils/geocode_helper.dart';
import '../datasources/places_data_source.dart';
import '../models/place_model.dart';

abstract class PlacesRepository {
  Future<Either<AppException, List<PlaceModel>>> getPlaces(String location);
}

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesDataSource remoteDataSource;

  PlacesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<AppException, List<PlaceModel>>> getPlaces(
    String location,
  ) async {
    try {
      final response = await remoteDataSource.getPlaces(location);

      // Get default coordinates for the location
      final locationCoordinates = GeocodeHelper.getCoordinates(location);

      final places = response.destinations.map((destination) {
        // Try to get coordinates for the specific place first
        final placeCoordinates =
            GeocodeHelper.getCoordinates(destination.title) ??
            locationCoordinates;

        return PlaceModel(
          title: destination.title,
          location: location,
          description: destination.description,
          thumbnailUrl: destination.thumbnail,
          flightPrice: destination.flightPrice,
          extractedFlightPrice: destination.extractedFlightPrice,
          hotelPrice: destination.hotelPrice,
          extractedHotelPrice: destination.extractedHotelPrice,
          link: destination.link,
          latitude: placeCoordinates?.latitude,
          longitude: placeCoordinates?.longitude,
        );
      }).toList();

      return Right(places);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(message: 'An unexpected error occurred: $e'));
    }
  }
}
