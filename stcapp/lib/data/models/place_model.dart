import 'package:equatable/equatable.dart';

class PlaceModel extends Equatable {
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
  final double? latitude;
  final double? longitude;

  const PlaceModel({
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
    this.latitude,
    this.longitude,
  });

  // Factory constructor to create PlaceModel from JSON
  factory PlaceModel.fromJson(
    Map<String, dynamic> json,
    String location, {
    double? latitude,
    double? longitude,
  }) {
    return PlaceModel(
      title: json['title'] as String? ?? 'Unknown',
      location: location,
      description: json['description'] as String? ?? 'No description available',
      thumbnailUrl: json['thumbnail'] as String?,
      flightPrice: json['flight_price'] as String?,
      extractedFlightPrice: json['extracted_flight_price'] as int?,
      hotelPrice: json['hotel_price'] as String?,
      extractedHotelPrice: json['extracted_hotel_price'] as int?,
      link: json['link'] as String?,
      isFavorite: false,
      latitude: latitude,
      longitude: longitude,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'location': location,
      'description': description,
      'thumbnail': thumbnailUrl,
      'flight_price': flightPrice,
      'extracted_flight_price': extractedFlightPrice,
      'hotel_price': hotelPrice,
      'extracted_hotel_price': extractedHotelPrice,
      'link': link,
      'isFavorite': isFavorite,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Copy with method for immutability
  PlaceModel copyWith({
    String? title,
    String? location,
    String? description,
    String? thumbnailUrl,
    String? flightPrice,
    int? extractedFlightPrice,
    String? hotelPrice,
    int? extractedHotelPrice,
    String? link,
    bool? isFavorite,
    double? latitude,
    double? longitude,
  }) {
    return PlaceModel(
      title: title ?? this.title,
      location: location ?? this.location,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      flightPrice: flightPrice ?? this.flightPrice,
      extractedFlightPrice: extractedFlightPrice ?? this.extractedFlightPrice,
      hotelPrice: hotelPrice ?? this.hotelPrice,
      extractedHotelPrice: extractedHotelPrice ?? this.extractedHotelPrice,
      link: link ?? this.link,
      isFavorite: isFavorite ?? this.isFavorite,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

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
    latitude,
    longitude,
  ];
}
