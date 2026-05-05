import 'package:equatable/equatable.dart';
import '../../../data/models/place_model.dart';
import '../../../core/utils/exception_handler.dart';

abstract class PlacesState extends Equatable {
  const PlacesState();

  @override
  List<Object?> get props => [];
}

class PlacesInitial extends PlacesState {
  const PlacesInitial();
}

class PlacesLoading extends PlacesState {
  const PlacesLoading();
}

class PlacesLoaded extends PlacesState {
  final List<PlaceModel> places;
  final String location;
  final bool isOffline;

  const PlacesLoaded({
    required this.places,
    required this.location,
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [places, location, isOffline];
}

class PlacesError extends PlacesState {
  final String message;
  final AppException? exception;

  const PlacesError({required this.message, this.exception});

  @override
  List<Object?> get props => [message, exception];
}

class PlacesEmpty extends PlacesState {
  final String message;

  const PlacesEmpty({required this.message});

  @override
  List<Object?> get props => [message];
}
