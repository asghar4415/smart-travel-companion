import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final String title;
  final String location;
  final String description;
  final String? thumbnailUrl;
  final String? flightPrice;
  final int? extractedFlightPrice;
  final String? hotelPrice;
  final int? extractedHotelPrice;
  final String? link;
  final bool isFavorite;

  const Place({
    required this.title,
    required this.location,
    required this.description,
    this.thumbnailUrl,
    this.flightPrice,
    this.extractedFlightPrice,
    this.hotelPrice,
    this.extractedHotelPrice,
    this.link,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
    title,
    location,
    description,
    thumbnailUrl,
    flightPrice,
    extractedFlightPrice,
    hotelPrice,
    extractedHotelPrice,
    link,
    isFavorite,
  ];
}
