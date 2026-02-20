import 'package:latlong2/latlong.dart';
import '../../domain/entities/place_entity.dart';

/// موديل المكان - يحول بيانات Nominatim API إلى PlaceEntity
class PlaceModel extends PlaceEntity {
  const PlaceModel({
    required super.id,
    required super.name,
    required super.displayName,
    required super.position,
    super.type,
    super.category,
    super.isFavorite,
  });

  /// تحويل من JSON (Nominatim API response)
  factory PlaceModel.fromNominatimJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['place_id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['display_name']?.toString().split(',').first ?? '',
      displayName: json['display_name']?.toString() ?? '',
      position: LatLng(
        double.parse(json['lat'].toString()),
        double.parse(json['lon'].toString()),
      ),
      type: json['type']?.toString(),
      category: json['category']?.toString(),
    );
  }

  /// التحويل إلى JSON (للتخزين المحلي)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'lat': position.latitude,
      'lon': position.longitude,
      'type': type,
      'category': category,
      'isFavorite': isFavorite,
    };
  }

  /// التحويل من JSON المحلي
  factory PlaceModel.fromLocalJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      position: LatLng(
        (json['lat'] as num).toDouble(),
        (json['lon'] as num).toDouble(),
      ),
      type: json['type']?.toString(),
      category: json['category']?.toString(),
      isFavorite: json['isFavorite'] as bool? ?? true,
    );
  }
}
