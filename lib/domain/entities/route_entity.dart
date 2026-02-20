import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// كيان المسار - يمثل مسار بين نقطتين
class RouteEntity extends Equatable {
  final LatLng origin;
  final LatLng destination;
  final List<LatLng> polylinePoints;
  final double distanceKm;
  final double durationMinutes;
  final String? originName;
  final String? destinationName;

  const RouteEntity({
    required this.origin,
    required this.destination,
    required this.polylinePoints,
    required this.distanceKm,
    required this.durationMinutes,
    this.originName,
    this.destinationName,
  });

  /// المسافة منسقة كنص
  String get formattedDistance {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()} م';
    }
    return '${distanceKm.toStringAsFixed(1)} كم';
  }

  /// الزمن منسق كنص
  String get formattedDuration {
    final hours = durationMinutes ~/ 60;
    final minutes = (durationMinutes % 60).round();
    if (hours > 0) {
      return '${hours} س ${minutes} د';
    }
    return '$minutes د';
  }

  @override
  List<Object?> get props => [
        origin,
        destination,
        polylinePoints,
        distanceKm,
        durationMinutes,
      ];
}
