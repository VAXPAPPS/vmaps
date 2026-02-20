import 'package:latlong2/latlong.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/nominatim_data_source.dart';
import '../datasources/osrm_data_source.dart';
import '../datasources/favorites_local_source.dart';
import '../models/place_model.dart';

/// التنفيذ الفعلي للمستودع
class MapRepositoryImpl implements MapRepository {
  final NominatimDataSource _nominatim;
  final OsrmDataSource _osrm;
  final FavoritesLocalSource _favoritesLocal;

  MapRepositoryImpl({
    NominatimDataSource? nominatim,
    OsrmDataSource? osrm,
    FavoritesLocalSource? favoritesLocal,
  })  : _nominatim = nominatim ?? NominatimDataSource(),
        _osrm = osrm ?? OsrmDataSource(),
        _favoritesLocal = favoritesLocal ?? FavoritesLocalSource();

  @override
  Future<List<PlaceEntity>> searchPlaces(String query) async {
    return await _nominatim.search(query);
  }

  @override
  Future<PlaceEntity?> reverseGeocode(LatLng position) async {
    return await _nominatim.reverseGeocode(
      position.latitude,
      position.longitude,
    );
  }

  @override
  Future<RouteEntity> getRoute(LatLng origin, LatLng destination) async {
    return await _osrm.getRoute(origin, destination);
  }

  @override
  Future<List<PlaceEntity>> getFavorites() async {
    return await _favoritesLocal.getFavorites();
  }

  @override
  Future<void> addFavorite(PlaceEntity place) async {
    final model = PlaceModel(
      id: place.id,
      name: place.name,
      displayName: place.displayName,
      position: place.position,
      type: place.type,
      category: place.category,
      isFavorite: true,
    );
    await _favoritesLocal.addFavorite(model);
  }

  @override
  Future<void> removeFavorite(String placeId) async {
    await _favoritesLocal.removeFavorite(placeId);
  }
}
