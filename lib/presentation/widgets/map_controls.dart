import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/map_styles.dart';

/// أزرار التحكم بالخريطة
class MapControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onLayerSwitch;
  final VoidCallback? onMyLocation;

  const MapControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onLayerSwitch,
    this.onMyLocation,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: MapStyles.glassDecoration(opacity: 0.12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ControlButton(
                icon: Icons.add,
                onTap: onZoomIn,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              Container(height: 1, color: Colors.white10),
              _ControlButton(
                icon: Icons.remove,
                onTap: onZoomOut,
              ),
              Container(height: 1, color: Colors.white10),
              _ControlButton(
                icon: Icons.layers,
                onTap: onLayerSwitch,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.borderRadius,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: widget.borderRadius,
          ),
          child: Icon(
            widget.icon,
            color: _isHovered ? Colors.white : Colors.white70,
            size: 20,
          ),
        ),
      ),
    );
  }
}
