import 'package:equatable/equatable.dart';
import '../../domain/entities/place_entity.dart';

/// أحداث المفضلة
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {}

class AddFavoriteEvent extends FavoritesEvent {
  final PlaceEntity place;
  const AddFavoriteEvent(this.place);
  @override
  List<Object?> get props => [place];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final String placeId;
  const RemoveFavoriteEvent(this.placeId);
  @override
  List<Object?> get props => [placeId];
}
