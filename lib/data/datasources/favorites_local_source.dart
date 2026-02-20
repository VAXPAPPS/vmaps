import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/place_model.dart';

/// مصدر بيانات محلي - تخزين الأماكن المفضلة
class FavoritesLocalSource {
  static const String _key = 'vaxp_maps_favorites';

  /// جلب جميع الأماكن المفضلة
  Future<List<PlaceModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> data = json.decode(jsonString);
    return data.map((e) => PlaceModel.fromLocalJson(e as Map<String, dynamic>)).toList();
  }

  /// إضافة مكان للمفضلة
  Future<void> addFavorite(PlaceModel place) async {
    final favorites = await getFavorites();
    // تجنب التكرار
    if (favorites.any((f) => f.id == place.id)) return;

    final updatedPlace = PlaceModel(
      id: place.id,
      name: place.name,
      displayName: place.displayName,
      position: place.position,
      type: place.type,
      category: place.category,
      isFavorite: true,
    );
    favorites.add(updatedPlace);
    await _saveFavorites(favorites);
  }

  /// حذف مكان من المفضلة
  Future<void> removeFavorite(String placeId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((f) => f.id == placeId);
    await _saveFavorites(favorites);
  }

  /// حفظ القائمة
  Future<void> _saveFavorites(List<PlaceModel> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(favorites.map((f) => f.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }
}
