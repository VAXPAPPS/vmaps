import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/map/map_bloc.dart';
import '../../application/map/map_event.dart';
import '../../application/map/map_state.dart';
import '../../application/route/route_bloc.dart';
import '../../application/route/route_event.dart';
import '../../application/route/route_state.dart';
import '../../core/consts/map_constants.dart';
import '../../core/theme/map_styles.dart';
import 'vaxp_marker.dart';

/// عرض الخريطة الرئيسي
class MapView extends StatefulWidget {
  final bool isRoutingMode;

  const MapView({super.key, this.isRoutingMode = false});

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) {
        if (state is MapLoaded) {
          try {
            _mapController.move(state.center, state.zoom);
          } catch (_) {
            // المتحكم قد لا يكون جاهزاً بعد
          }
        }
      },
      builder: (context, mapState) {
        if (mapState is! MapLoaded) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white54),
          );
        }

        final layer = MapConstants.layers[mapState.currentLayerIndex];

        return BlocBuilder<RouteBloc, RouteState>(
          builder: (context, routeState) {
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: mapState.center,
                initialZoom: mapState.zoom,
                minZoom: MapConstants.minZoom,
                maxZoom: MapConstants.maxZoom,
                onTap: (tapPosition, point) {
                  _handleMapTap(context, point);
                },
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                // طبقة الخريطة
                TileLayer(
                  urlTemplate: layer.urlTemplate,
                  subdomains: layer.subdomains,
                  userAgentPackageName: 'com.vaxp.maps',
                  maxZoom: 19,
                ),

                // طبقة المسار
                if (routeState is RouteLoaded)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routeState.route.polylinePoints,
                        color: MapStyles.routeColor,
                        strokeWidth: MapStyles.routeWidth,
                        borderColor: MapStyles.routeOutlineColor,
                        borderStrokeWidth: 1.5,
                      ),
                    ],
                  ),

                // طبقة العلامات
                MarkerLayer(
                  markers: [
                    // علامات عادية
                    ...mapState.markers.map(
                      (m) => Marker(
                        point: m.position,
                        width: 120,
                        height: 60,
                        alignment: Alignment.topCenter,
                        child: VaxpMarkerWidget(
                          label: m.label,
                          isSelected:
                              mapState.selectedPlace != null &&
                              mapState.selectedPlace!.position == m.position,
                        ),
                      ),
                    ),

                    // علامات المسار (بداية ونهاية)
                    if (routeState is RouteLoaded) ...[
                      Marker(
                        point: routeState.route.origin,
                        width: 40,
                        height: 40,
                        child: const VaxpMarkerWidget(
                          color: MapStyles.originMarkerColor,
                        ),
                      ),
                      Marker(
                        point: routeState.route.destination,
                        width: 40,
                        height: 40,
                        child: const VaxpMarkerWidget(
                          color: MapStyles.destinationMarkerColor,
                        ),
                      ),
                    ],
                  ],
                ),

                // إسناد
                RichAttributionWidget(
                  alignment: AttributionAlignment.bottomLeft,
                  attributions: [
                    TextSourceAttribution(
                      layer.attribution,
                      textStyle: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleMapTap(BuildContext context, LatLng point) {
    if (widget.isRoutingMode) {
      // في وضع المسار: تعيين البداية أو الوجهة
      final routeBloc = context.read<RouteBloc>();
      final routeState = routeBloc.state;
      if (routeState is RouteInitial || routeState is RouteError) {
        routeBloc.add(SetOriginEvent(point, name: 'نقطة البداية'));
      } else if (routeState is RoutePointsSet &&
          routeState.origin != null &&
          routeState.destination == null) {
        routeBloc.add(SetDestinationEvent(point, name: 'الوجهة'));
      }
    } else {
      // الوضع العادي: Reverse Geocoding
      context.read<MapBloc>().add(TapOnMapEvent(point));
    }
  }

  /// الوصول إلى المتحكم من الخارج
  MapController get mapController => _mapController;
}
