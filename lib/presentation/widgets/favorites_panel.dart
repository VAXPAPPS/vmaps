import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/favorites/favorites_bloc.dart';
import '../../application/favorites/favorites_event.dart';
import '../../application/favorites/favorites_state.dart';
import '../../application/map/map_bloc.dart';
import '../../application/map/map_event.dart';
import '../../core/theme/map_styles.dart';
import '../../domain/entities/place_entity.dart';

/// لوحة الأماكن المفضلة
class FavoritesPanel extends StatelessWidget {
  final VoidCallback? onClose;

  const FavoritesPanel({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: 380,
          constraints: const BoxConstraints(maxHeight: 450),
          decoration: MapStyles.glassDecoration(),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // العنوان
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.redAccent, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'الأماكن المفضلة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (onClose != null)
                    GestureDetector(
                      onTap: onClose,
                      child: const Icon(Icons.close, color: Colors.white54, size: 20),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // القائمة
              Flexible(
                child: BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    if (state is FavoritesLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white54,
                          ),
                        ),
                      );
                    }

                    if (state is FavoritesLoaded) {
                      if (state.places.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.favorite_border, color: Colors.white24, size: 48),
                              SizedBox(height: 12),
                              Text(
                                'لا توجد أماكن محفوظة',
                                style: TextStyle(color: Colors.white38, fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'انقر على الخريطة واحفظ أماكنك المفضلة',
                                style: TextStyle(color: Colors.white24, fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.places.length,
                        itemBuilder: (context, index) {
                          return _buildFavoriteItem(context, state.places[index]);
                        },
                      );
                    }

                    if (state is FavoritesError) {
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(BuildContext context, PlaceEntity place) {
    return Dismissible(
      key: Key(place.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
      ),
      onDismissed: (_) {
        context.read<FavoritesBloc>().add(RemoveFavoriteEvent(place.id));
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            context.read<MapBloc>().add(
                  MoveCameraEvent(place.position, zoom: 15.0),
                );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.favorite, color: Colors.redAccent, size: 18),
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
                const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
