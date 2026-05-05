import 'package:equatable/equatable.dart';

class PlaceModel extends Equatable {
  final String title;
  final String location;
  final String description;
  final String? thumbnailUrl;
  final bool isFavorite;
  final double? latitude;
  final double? longitude;

  const PlaceModel({
    required this.title,
    required this.location,
    required this.description,
    this.thumbnailUrl,

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
    bool? isFavorite,
    double? latitude,
    double? longitude,
  }) {
    return PlaceModel(
      title: title ?? this.title,
      location: location ?? this.location,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
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
    isFavorite,
    latitude,
    longitude,
  ];
}
