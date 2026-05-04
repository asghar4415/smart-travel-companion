import 'package:equatable/equatable.dart';

class PlacesResponseModel extends Equatable {
  final List<Destination> destinations;

  const PlacesResponseModel({required this.destinations});

  factory PlacesResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      final popularDestinations =
          json['popular_destinations'] as Map<String, dynamic>?;

      if (popularDestinations == null) {
        return const PlacesResponseModel(destinations: []);
      }

      final destinationsList =
          popularDestinations['destinations'] as List<dynamic>? ?? [];

      final destinations = destinationsList
          .whereType<Map<String, dynamic>>()
          .map((item) => Destination.fromJson(item))
          .take(10) // Limit to top 10 destinations
          .toList();

      return PlacesResponseModel(destinations: destinations);
    } catch (e) {
      print('Error parsing PlacesResponseModel: $e');
      return const PlacesResponseModel(destinations: []);
    }
  }

  @override
  List<Object?> get props => [destinations];
}

class Destination extends Equatable {
  final String title;
  final String? link;
  final String description;
  final String? flightPrice;
  final int? extractedFlightPrice;
  final String? hotelPrice;
  final int? extractedHotelPrice;
  final String? thumbnail;

  const Destination({
    required this.title,
    this.link,
    required this.description,
    this.flightPrice,
    this.extractedFlightPrice,
    this.hotelPrice,
    this.extractedHotelPrice,
    this.thumbnail,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      title: json['title'] as String? ?? 'Unknown',
      link: json['link'] as String?,
      description: json['description'] as String? ?? 'No description',
      flightPrice: json['flight_price'] as String?,
      extractedFlightPrice: json['extracted_flight_price'] as int?,
      hotelPrice: json['hotel_price'] as String?,
      extractedHotelPrice: json['extracted_hotel_price'] as int?,
      thumbnail: json['thumbnail'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    title,
    link,
    description,
    flightPrice,
    extractedFlightPrice,
    hotelPrice,
    extractedHotelPrice,
    thumbnail,
  ];
}
