import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/map/map_bloc.dart';
import '../../application/map/map_event.dart';
import '../../core/consts/map_constants.dart';
import '../../core/theme/map_styles.dart';
import 'package:latlong2/latlong.dart';

/// لوحة الإعدادات
class SettingsPanel extends StatelessWidget {
  final VoidCallback? onClose;

  const SettingsPanel({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: 380,
          decoration: MapStyles.glassDecoration(),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان
              Row(
                children: [
                  const Icon(Icons.settings, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'الإعدادات',
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
                      child: const Icon(
                        Icons.close,
                        color: Colors.white54,
                        size: 20,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // الانتقال السريع لمواقع محددة
              const Text(
                'الانتقال السريع',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              _QuickLocationButton(
                icon: Icons.location_city,
                label: 'الرياض',
                subtitle: 'المملكة العربية السعودية',
                onTap: () {
                  context.read<MapBloc>().add(
                    const MoveCameraEvent(LatLng(24.7136, 46.6753), zoom: 11.0),
                  );
                },
              ),
              _QuickLocationButton(
                icon: Icons.location_city,
                label: 'مكة المكرمة',
                subtitle: 'المملكة العربية السعودية',
                onTap: () {
                  context.read<MapBloc>().add(
                    const MoveCameraEvent(LatLng(21.4225, 39.8262), zoom: 12.0),
                  );
                },
              ),
              _QuickLocationButton(
                icon: Icons.location_city,
                label: 'دبي',
                subtitle: 'الإمارات العربية المتحدة',
                onTap: () {
                  context.read<MapBloc>().add(
                    const MoveCameraEvent(LatLng(25.2048, 55.2708), zoom: 11.0),
                  );
                },
              ),
              _QuickLocationButton(
                icon: Icons.location_city,
                label: 'القاهرة',
                subtitle: 'مصر',
                onTap: () {
                  context.read<MapBloc>().add(
                    const MoveCameraEvent(LatLng(30.0444, 31.2357), zoom: 11.0),
                  );
                },
              ),

              const SizedBox(height: 16),

              // إعادة التعيين
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<MapBloc>().add(
                      MoveCameraEvent(
                        const LatLng(
                          MapConstants.defaultLat,
                          MapConstants.defaultLng,
                        ),
                        zoom: MapConstants.defaultZoom,
                      ),
                    );
                  },
                  icon: const Icon(Icons.restart_alt, size: 16),
                  label: const Text('إعادة تعيين الخريطة'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // معلومات التطبيق
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vaxp Maps v1.0',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'مبني بتقنية Flutter + OpenStreetMap',
                      style: TextStyle(color: Colors.white30, fontSize: 11),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'خرائط OpenStreetMap • بحث Nominatim • مسارات OSRM',
                      style: TextStyle(color: Colors.white24, fontSize: 10),
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
}

/// زر الانتقال السريع
class _QuickLocationButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickLocationButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_QuickLocationButton> createState() => _QuickLocationButtonState();
}

class _QuickLocationButtonState extends State<_QuickLocationButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: MapStyles.routeColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: _isHovered ? Colors.white54 : Colors.white24,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
