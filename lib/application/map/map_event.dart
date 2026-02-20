import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// أحداث الخريطة
abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

/// تحريك الكاميرا إلى نقطة
class MoveCameraEvent extends MapEvent {
  final LatLng position;
  final double? zoom;

  const MoveCameraEvent(this.position, {this.zoom});

  @override
  List<Object?> get props => [position, zoom];
}

/// تقريب
class ZoomInEvent extends MapEvent {}

/// تبعيد
class ZoomOutEvent extends MapEvent {}

/// تغيير طبقة الخريطة
class ChangeLayerEvent extends MapEvent {
  final int layerIndex;

  const ChangeLayerEvent(this.layerIndex);

  @override
  List<Object?> get props => [layerIndex];
}

/// إضافة علامة
class AddMarkerEvent extends MapEvent {
  final LatLng position;
  final String? label;

  const AddMarkerEvent(this.position, {this.label});

  @override
  List<Object?> get props => [position, label];
}

/// حذف علامة
class RemoveMarkerEvent extends MapEvent {
  final String markerId;

  const RemoveMarkerEvent(this.markerId);

  @override
  List<Object?> get props => [markerId];
}

/// مسح جميع العلامات
class ClearMarkersEvent extends MapEvent {}

/// النقر على الخريطة (Reverse Geocoding)
class TapOnMapEvent extends MapEvent {
  final LatLng position;

  const TapOnMapEvent(this.position);

  @override
  List<Object?> get props => [position];
}

/// تهيئة الخريطة
class InitializeMapEvent extends MapEvent {}
