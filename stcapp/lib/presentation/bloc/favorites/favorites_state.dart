import 'package:equatable/equatable.dart';
import '../../../data/models/place_model.dart';
import '../../../core/utils/exception_handler.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<PlaceModel> favorites;

  const FavoritesLoaded({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

class FavoritesEmpty extends FavoritesState {
  final String message;

  const FavoritesEmpty({required this.message});

  @override
  List<Object> get props => [message];
}

class FavoritesError extends FavoritesState {
  final String message;
  final AppException exception;

  const FavoritesError({required this.message, required this.exception});

  @override
  List<Object> get props => [message, exception];
}
