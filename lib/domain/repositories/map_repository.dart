import 'package:latlong2/latlong.dart';
import '../entities/place_entity.dart';
import '../entities/route_entity.dart';

/// واجهة المستودع الرئيسية - تحدد العمليات المتاحة
abstract class MapRepository {
  /// البحث عن أماكن بالاسم
  Future<List<PlaceEntity>> searchPlaces(String query);

  /// Reverse Geocoding - الحصول على عنوان من إحداثيات
  Future<PlaceEntity?> reverseGeocode(LatLng position);

  /// حساب مسار بين نقطتين
  Future<RouteEntity> getRoute(LatLng origin, LatLng destination);

  /// الحصول على الأماكن المفضلة
  Future<List<PlaceEntity>> getFavorites();

  /// إضافة مكان للمفضلة
  Future<void> addFavorite(PlaceEntity place);

  /// حذف مكان من المفضلة
  Future<void> removeFavorite(String placeId);
}
