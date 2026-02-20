import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/search/search_bloc.dart';
import '../../application/search/search_event.dart';
import '../../application/search/search_state.dart';
import '../../application/map/map_bloc.dart';
import '../../application/map/map_event.dart';
import '../../core/theme/map_styles.dart';
import '../../domain/entities/place_entity.dart';

/// لوحة البحث الزجاجية
class SearchPanel extends StatefulWidget {
  final Function(PlaceEntity place)? onPlaceSelected;

  const SearchPanel({super.key, this.onPlaceSelected});

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      width: 380,
      constraints: BoxConstraints(
        maxHeight: _isExpanded ? 450 : 50,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: MapStyles.glassDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // شريط البحث
                _buildSearchBar(),
                // النتائج
                Flexible(child: _buildResults()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'ابحث عن مكان...',
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              onChanged: (value) {
                context.read<SearchBloc>().add(SearchQueryChanged(value));
                setState(() => _isExpanded = value.isNotEmpty);
              },
              onSubmitted: (value) {
                context.read<SearchBloc>().add(SearchSubmitted(value));
              },
            ),
          ),
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                context.read<SearchBloc>().add(ClearSearch());
                setState(() => _isExpanded = false);
              },
              child: const Icon(Icons.close, color: Colors.white54, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white54,
                ),
              ),
            ),
          );
        }

        if (state is SearchLoaded) {
          if (state.results.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'لا توجد نتائج',
                style: TextStyle(color: Colors.white38),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 8),
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final place = state.results[index];
              return _buildResultItem(place);
            },
          );
        }

        if (state is SearchError) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildResultItem(PlaceEntity place) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // تحريك الخريطة إلى المكان
          context.read<MapBloc>().add(MoveCameraEvent(place.position, zoom: 15.0));
          context.read<MapBloc>().add(AddMarkerEvent(place.position, label: place.name));
          widget.onPlaceSelected?.call(place);

          // مسح البحث
          _controller.clear();
          context.read<SearchBloc>().add(ClearSearch());
          setState(() => _isExpanded = false);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getIconForType(place.type),
                  color: Colors.white70,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      place.displayName,
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'city':
      case 'town':
      case 'village':
        return Icons.location_city;
      case 'restaurant':
      case 'cafe':
        return Icons.restaurant;
      case 'hospital':
        return Icons.local_hospital;
      case 'school':
      case 'university':
        return Icons.school;
      case 'park':
        return Icons.park;
      default:
        return Icons.place;
    }
  }
}
