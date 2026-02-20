import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/map_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

/// BLoC المفضلة - إدارة الأماكن المحفوظة
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final MapRepository _repository;

  FavoritesBloc({required MapRepository repository})
      : _repository = repository,
        super(FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorites(LoadFavoritesEvent event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final favorites = await _repository.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError('فشل تحميل المفضلة: ${e.toString()}'));
    }
  }

  Future<void> _onAddFavorite(AddFavoriteEvent event, Emitter<FavoritesState> emit) async {
    try {
      await _repository.addFavorite(event.place);
      // إعادة تحميل القائمة
      final favorites = await _repository.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError('فشل إضافة المفضلة: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFavorite(RemoveFavoriteEvent event, Emitter<FavoritesState> emit) async {
    try {
      await _repository.removeFavorite(event.placeId);
      final favorites = await _repository.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError('فشل حذف المفضلة: ${e.toString()}'));
    }
  }
}
