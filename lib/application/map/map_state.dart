import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/place_entity.dart';

/// حالة علامة على الخريطة
class MapMarker extends Equatable {
  final String id;
  final LatLng position;
  final String? label;

  const MapMarker({
    required this.id,
    required this.position,
    this.label,
  });

  @override
  List<Object?> get props => [id, position, label];
}

/// حالات الخريطة
abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class MapInitial extends MapState {}

/// الخريطة جاهزة
class MapLoaded extends MapState {
  final LatLng center;
  final double zoom;
  final int currentLayerIndex;
  final List<MapMarker> markers;
  final PlaceEntity? selectedPlace;

  const MapLoaded({
    required this.center,
    required this.zoom,
    this.currentLayerIndex = 0,
    this.markers = const [],
    this.selectedPlace,
  });

  MapLoaded copyWith({
    LatLng? center,
    double? zoom,
    int? currentLayerIndex,
    List<MapMarker>? markers,
    PlaceEntity? selectedPlace,
    bool clearSelectedPlace = false,
  }) {
    return MapLoaded(
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
      currentLayerIndex: currentLayerIndex ?? this.currentLayerIndex,
      markers: markers ?? this.markers,
      selectedPlace: clearSelectedPlace ? null : (selectedPlace ?? this.selectedPlace),
    );
  }

  @override
  List<Object?> get props => [center, zoom, currentLayerIndex, markers, selectedPlace];
}

/// خطأ في الخريطة
class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}
