import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/consts/map_constants.dart';
import '../../core/theme/map_styles.dart';

/// قائمة تبديل طبقات الخريطة
class LayerSwitcher extends StatelessWidget {
  final int currentIndex;
  final Function(int) onLayerSelected;
  final VoidCallback? onClose;

  const LayerSwitcher({
    super.key,
    required this.currentIndex,
    required this.onLayerSelected,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: 200,
          decoration: MapStyles.glassDecoration(),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.layers, color: Colors.white70, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'طبقات الخريطة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (onClose != null)
                    GestureDetector(
                      onTap: onClose,
                      child: const Icon(Icons.close, color: Colors.white38, size: 16),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              ...List.generate(MapConstants.layers.length, (index) {
                final layer = MapConstants.layers[index];
                final isSelected = index == currentIndex;

                return GestureDetector(
                  onTap: () => onLayerSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MapStyles.routeColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(color: MapStyles.routeColor.withOpacity(0.4))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getIcon(layer.icon),
                          color: isSelected ? MapStyles.routeColor : Colors.white54,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          layer.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        if (isSelected) ...[
                          const Spacer(),
                          const Icon(Icons.check, color: MapStyles.routeColor, size: 16),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'map':
        return Icons.map;
      case 'dark_mode':
        return Icons.dark_mode;
      case 'terrain':
        return Icons.terrain;
      case 'favorite':
        return Icons.volunteer_activism;
      default:
        return Icons.map;
    }
  }
}
