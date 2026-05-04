import 'package:equatable/equatable.dart';
import '../../../domain/entities/search_filter.dart';

abstract class PlacesEvent extends Equatable {
  const PlacesEvent();

  @override
  List<Object?> get props => [];
}

class GetPlacesEvent extends PlacesEvent {
  final String location;

  const GetPlacesEvent({required this.location});

  @override
  List<Object?> get props => [location];
}

class RefreshPlacesEvent extends PlacesEvent {
  final String location;

  const RefreshPlacesEvent({required this.location});

  @override
  List<Object?> get props => [location];
}

class ToggleFavoriteEvent extends PlacesEvent {
  final int index;

  const ToggleFavoriteEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class ClearPlacesEvent extends PlacesEvent {
  const ClearPlacesEvent();
}

class SearchAndFilterEvent extends PlacesEvent {
  final String location;
  final SearchFilter filter;

  const SearchAndFilterEvent({required this.location, required this.filter});

  @override
  List<Object?> get props => [location, filter];
}
