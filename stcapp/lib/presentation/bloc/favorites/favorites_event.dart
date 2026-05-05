import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class GetFavoritesEvent extends FavoritesEvent {
  const GetFavoritesEvent();

  @override
  List<Object> get props => [];
}

class AddFavoriteEvent extends FavoritesEvent {
  final String placeTitle;

  const AddFavoriteEvent({required this.placeTitle});

  @override
  List<Object> get props => [placeTitle];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final String placeTitle;

  const RemoveFavoriteEvent({required this.placeTitle});

  @override
  List<Object> get props => [placeTitle];
}
