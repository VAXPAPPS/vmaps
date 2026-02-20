import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/map/map_bloc.dart';
import '../../application/map/map_event.dart';
import '../../application/map/map_state.dart';
import '../../application/route/route_bloc.dart';
import '../../application/route/route_event.dart';
import '../../application/favorites/favorites_bloc.dart';
import '../../application/favorites/favorites_event.dart';
import '../../core/venom_layout.dart';
import '../widgets/map_view.dart';
import '../widgets/search_panel.dart';
import '../widgets/route_panel.dart';
import '../widgets/place_info_card.dart';
import '../widgets/map_controls.dart';
import '../widgets/sidebar.dart';
import '../widgets/layer_switcher.dart';
import '../widgets/favorites_panel.dart';
import '../widgets/settings_panel.dart';

/// الصفحة الرئيسية للخرائط
class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  int _selectedSidebarIndex = 0;
  bool _showLayerSwitcher = false;

  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(InitializeMapEvent());
    context.read<FavoritesBloc>().add(LoadFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return VenomScaffold(
      title: "Vaxp Maps",
      body: Row(
        children: [
          // الشريط الجانبي
          Sidebar(
            selectedIndex: _selectedSidebarIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedSidebarIndex = index;
                _showLayerSwitcher = false;
              });
            },
          ),

          // المحتوى الرئيسي
          Expanded(
            child: Stack(
              children: [
                // الخريطة
                MapView(isRoutingMode: _selectedSidebarIndex == 2),

                // لوحة البحث (أعلى يسار)
                if (_selectedSidebarIndex == 1)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: SearchPanel(
                      onPlaceSelected: (place) {
                        setState(() => _selectedSidebarIndex = 0);
                      },
                    ),
                  ),

                // لوحة المسار (أعلى يسار)
                if (_selectedSidebarIndex == 2)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: RoutePanel(
                      onClose: () {
                        context.read<RouteBloc>().add(ClearRouteEvent());
                        setState(() => _selectedSidebarIndex = 0);
                      },
                    ),
                  ),

                // لوحة المفضلة (أعلى يسار)
                if (_selectedSidebarIndex == 3)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: FavoritesPanel(
                      onClose: () {
                        setState(() => _selectedSidebarIndex = 0);
                      },
                    ),
                  ),

                // لوحة الإعدادات (أعلى يسار)
                if (_selectedSidebarIndex == 4)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: SettingsPanel(
                      onClose: () {
                        setState(() => _selectedSidebarIndex = 0);
                      },
                    ),
                  ),

                // أزرار التحكم (يمين)
                Positioned(
                  right: 16,
                  bottom: 80,
                  child: MapControls(
                    onZoomIn: () {
                      context.read<MapBloc>().add(ZoomInEvent());
                    },
                    onZoomOut: () {
                      context.read<MapBloc>().add(ZoomOutEvent());
                    },
                    onLayerSwitch: () {
                      setState(() {
                        _showLayerSwitcher = !_showLayerSwitcher;
                      });
                    },
                  ),
                ),

                // قائمة الطبقات
                if (_showLayerSwitcher)
                  Positioned(
                    right: 70,
                    bottom: 80,
                    child: BlocBuilder<MapBloc, MapState>(
                      builder: (context, state) {
                        final currentLayer = state is MapLoaded
                            ? state.currentLayerIndex
                            : 0;
                        return LayerSwitcher(
                          currentIndex: currentLayer,
                          onLayerSelected: (index) {
                            context.read<MapBloc>().add(
                              ChangeLayerEvent(index),
                            );
                            setState(() => _showLayerSwitcher = false);
                          },
                          onClose: () {
                            setState(() => _showLayerSwitcher = false);
                          },
                        );
                      },
                    ),
                  ),

                // بطاقة معلومات المكان (أسفل يسار)
                BlocBuilder<MapBloc, MapState>(
                  builder: (context, state) {
                    if (state is MapLoaded && state.selectedPlace != null) {
                      return Positioned(
                        bottom: 20,
                        left: 12,
                        child: PlaceInfoCard(
                          place: state.selectedPlace!,
                          onClose: () {
                            context.read<MapBloc>().add(ClearMarkersEvent());
                          },
                          onFavorite: () {
                            context.read<FavoritesBloc>().add(
                              AddFavoriteEvent(state.selectedPlace!),
                            );
                          },
                          onRoute: () {
                            context.read<RouteBloc>().add(
                              SetOriginEvent(
                                state.selectedPlace!.position,
                                name: state.selectedPlace!.name,
                              ),
                            );
                            setState(() => _selectedSidebarIndex = 2);
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
