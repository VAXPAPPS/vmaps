import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/route/route_bloc.dart';
import '../../application/route/route_event.dart';
import '../../application/route/route_state.dart';
import '../../core/theme/map_styles.dart';

/// لوحة تخطيط المسار
class RoutePanel extends StatelessWidget {
  final VoidCallback? onClose;

  const RoutePanel({super.key, this.onClose});

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
          child: BlocBuilder<RouteBloc, RouteState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // العنوان
                  Row(
                    children: [
                      const Icon(Icons.route, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'تخطيط المسار',
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
                  const SizedBox(height: 16),

                  // التعليمات
                  if (state is RouteInitial || state is RoutePointsSet) ...[
                    _buildInstruction(
                      icon: Icons.circle,
                      color: MapStyles.originMarkerColor,
                      text: state is RoutePointsSet && (state).originName != null
                          ? (state).originName!
                          : 'انقر على الخريطة لتحديد البداية',
                      isSet: state is RoutePointsSet && (state).origin != null,
                    ),
                    const SizedBox(height: 8),
                    _buildInstruction(
                      icon: Icons.location_on,
                      color: MapStyles.destinationMarkerColor,
                      text: state is RoutePointsSet && (state).destinationName != null
                          ? (state).destinationName!
                          : 'انقر مرة أخرى لتحديد الوجهة',
                      isSet: state is RoutePointsSet && (state).destination != null,
                    ),
                    const SizedBox(height: 16),

                    // زر حساب المسار
                    if (state is RoutePointsSet &&
                        state.origin != null &&
                        state.destination != null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<RouteBloc>().add(CalculateRouteEvent());
                          },
                          icon: const Icon(Icons.directions, size: 18),
                          label: const Text('حساب المسار'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MapStyles.routeColor.withOpacity(0.8),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                  ],

                  // جاري الحساب
                  if (state is RouteCalculating) ...[
                    const SizedBox(height: 16),
                    const Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white54,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'جاري حساب المسار...',
                            style: TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // المسار محمّل
                  if (state is RouteLoaded) ...[
                    _buildRouteInfo(state),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<RouteBloc>().add(ClearRouteEvent());
                        },
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('مسار جديد'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white70,
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],

                  // خطأ
                  if (state is RouteError) ...[
                    const SizedBox(height: 8),
                    Text(
                      (state).message,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        context.read<RouteBloc>().add(ClearRouteEvent());
                      },
                      child: const Text('حاول مجدداً', style: TextStyle(color: Colors.white54)),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction({
    required IconData icon,
    required Color color,
    required String text,
    required bool isSet,
  }) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isSet ? Colors.white : Colors.white38,
              fontSize: 13,
              fontWeight: isSet ? FontWeight.w500 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isSet) const Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
      ],
    );
  }

  Widget _buildRouteInfo(RouteLoaded state) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            icon: Icons.straighten,
            label: 'المسافة',
            value: state.route.formattedDistance,
          ),
          Container(width: 1, height: 40, color: Colors.white12),
          _buildInfoItem(
            icon: Icons.timer,
            label: 'الزمن',
            value: state.route.formattedDuration,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: MapStyles.routeColor, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
      ],
    );
  }
}
