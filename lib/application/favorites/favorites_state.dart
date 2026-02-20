import 'package:equatable/equatable.dart';
import '../../domain/entities/place_entity.dart';

/// حالات المفضلة
abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<PlaceEntity> places;
  const FavoritesLoaded(this.places);
  @override
  List<Object?> get props => [places];
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
  @override
  List<Object?> get props => [message];
}
