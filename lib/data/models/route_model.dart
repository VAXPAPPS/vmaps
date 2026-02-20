import 'package:latlong2/latlong.dart';
import '../../domain/entities/route_entity.dart';

/// موديل المسار - يحول بيانات OSRM API إلى RouteEntity
class RouteModel extends RouteEntity {
  const RouteModel({
    required super.origin,
    required super.destination,
    required super.polylinePoints,
    required super.distanceKm,
    required super.durationMinutes,
    super.originName,
    super.destinationName,
  });

  /// تحويل من OSRM API response
  factory RouteModel.fromOsrmJson(
    Map<String, dynamic> json,
    LatLng origin,
    LatLng destination,
  ) {
    final route = json['routes'][0];
    final geometry = route['geometry'];

    // فك ترميز polyline
    final points = _decodePolyline(geometry as String);

    // المسافة بالكيلومتر
    final distanceMeters = (route['distance'] as num).toDouble();
    final distanceKm = distanceMeters / 1000;

    // الزمن بالدقائق
    final durationSeconds = (route['duration'] as num).toDouble();
    final durationMinutes = durationSeconds / 60;

    return RouteModel(
      origin: origin,
      destination: destination,
      polylinePoints: points,
      distanceKm: distanceKm,
      durationMinutes: durationMinutes,
    );
  }

  /// فك ترميز Polyline المشفر (Google Polyline Encoding)
  static List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int result = 0;
      int shift = 0;
      int byte;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      final dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      result = 0;
      shift = 0;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      final dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }
}
