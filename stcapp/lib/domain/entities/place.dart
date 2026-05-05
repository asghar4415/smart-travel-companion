import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final String title;
  final String location;
  final String description;
  final String? thumbnailUrl;
  final bool isFavorite;

  const Place({
    required this.title,
    required this.location,
    required this.description,
    this.thumbnailUrl,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
    title,
    location,
    description,
    thumbnailUrl,
    isFavorite,
  ];
}
