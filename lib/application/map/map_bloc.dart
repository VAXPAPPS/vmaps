import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/repositories/map_repository.dart';
import 'map_event.dart';
import 'map_state.dart';

/// BLoC الخريطة الرئيسي
class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository _repository;
  int _markerCounter = 0;

  MapBloc({required MapRepository repository})
      : _repository = repository,
        super(MapInitial()) {
    on<InitializeMapEvent>(_onInitialize);
    on<MoveCameraEvent>(_onMoveCamera);
    on<ZoomInEvent>(_onZoomIn);
    on<ZoomOutEvent>(_onZoomOut);
    on<ChangeLayerEvent>(_onChangeLayer);
    on<AddMarkerEvent>(_onAddMarker);
    on<RemoveMarkerEvent>(_onRemoveMarker);
    on<ClearMarkersEvent>(_onClearMarkers);
    on<TapOnMapEvent>(_onTapOnMap);
  }

  void _onInitialize(InitializeMapEvent event, Emitter<MapState> emit) {
    // الموقع الافتراضي: الرياض
    emit(const MapLoaded(
      center: LatLng(24.7136, 46.6753),
      zoom: 6.0,
    ));
  }

  void _onMoveCamera(MoveCameraEvent event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final current = state as MapLoaded;
      emit(current.copyWith(
        center: event.position,
        zoom: event.zoom,
      ));
    }
  }

  void _onZoomIn(ZoomInEvent event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final current = state as MapLoaded;
      final newZoom = (current.zoom + 1).clamp(2.0, 18.0);
      emit(current.copyWith(zoom: newZoom));
    }
  }

  void _onZoomOut(ZoomOutEvent event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final current = state as MapLoaded;
      final newZoom = (current.zoom - 1).clamp(2.0, 18.0);
      emit(current.copyWith(zoom: newZoom));
    }
  }

  void _onChangeLayer(ChangeLayerEvent event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final current = state as MapLoaded;
      emit(current.copyWith(currentLayerIndex: event.layerIndex));
    }
  }

  void _onAddMarker(AddMarkerEvent event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final current = state as MapLoaded;
      _markerCounter++;
      final marker = MapMarker(
        id: 'marker_$_markerCounter',
        position: event.position,
        label: event.label,
      );
      emit(current.copyWith(
        markers: [...current.markers, marker],
      ));
    }
  }

  void _onRemoveMarker(RemoveMarkerEvent event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final current = state as MapLoaded;
      emit(current.copyWith(
        markers: current.markers.where((m) => m.id != event.markerId).toList(),
      ));
    }
  }

  void _onClearMarkers(ClearMarkersEvent event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final current = state as MapLoaded;
      emit(current.copyWith(markers: [], clearSelectedPlace: true));
    }
  }

  Future<void> _onTapOnMap(TapOnMapEvent event, Emitter<MapState> emit) async {
    if (state is MapLoaded) {
      final current = state as MapLoaded;
      try {
        final place = await _repository.reverseGeocode(event.position);
        if (place != null) {
          // إضافة علامة + عرض معلومات المكان
          _markerCounter++;
          final marker = MapMarker(
            id: 'marker_$_markerCounter',
            position: event.position,
            label: place.name,
          );
          emit(current.copyWith(
            markers: [...current.markers, marker],
            selectedPlace: place,
          ));
        }
      } catch (e) {
        // في حالة فشل الاتصال، نضيف العلامة فقط
        _markerCounter++;
        final marker = MapMarker(
          id: 'marker_$_markerCounter',
          position: event.position,
        );
        emit(current.copyWith(
          markers: [...current.markers, marker],
        ));
      }
    }
  }
}
