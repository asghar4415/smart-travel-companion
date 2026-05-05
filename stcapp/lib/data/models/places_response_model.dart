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
  final String description;
  final String? thumbnail;

  const Destination({
    required this.title,
    required this.description,
    this.thumbnail,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      title: json['title'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? 'No description',
      thumbnail: json['thumbnail'] as String?,
    );
  }

  @override
  List<Object?> get props => [title, description, thumbnail];
}
