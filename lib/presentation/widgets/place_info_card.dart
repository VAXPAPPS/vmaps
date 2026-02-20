import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/map_styles.dart';
import '../../domain/entities/place_entity.dart';

/// بطاقة معلومات المكان
class PlaceInfoCard extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback? onClose;
  final VoidCallback? onFavorite;
  final VoidCallback? onRoute;
  final bool isFavorite;

  const PlaceInfoCard({
    super.key,
    required this.place,
    this.onClose,
    this.onFavorite,
    this.onRoute,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: 340,
          decoration: MapStyles.glassDecoration(),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان + زر الإغلاق
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: MapStyles.markerColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: MapStyles.markerColor,
                      size: 24,
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
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (place.type != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              place.type!,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (onClose != null)
                    GestureDetector(
                      onTap: onClose,
                      child: const Icon(Icons.close, color: Colors.white38, size: 18),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // العنوان الكامل
              Text(
                place.displayName,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // الإحداثيات
              Row(
                children: [
                  const Icon(Icons.gps_fixed, color: Colors.white24, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${place.position.latitude.toStringAsFixed(4)}, ${place.position.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(
                      color: Colors.white30,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                      label: isFavorite ? 'محفوظ' : 'حفظ',
                      color: isFavorite ? Colors.redAccent : Colors.white70,
                      onTap: onFavorite,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.directions,
                      label: 'الاتجاهات',
                      color: MapStyles.routeColor,
                      onTap: onRoute,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
