import 'package:flutter/material.dart';
import '../../core/theme/map_styles.dart';

/// علامة مخصصة بتصميم Vaxp
class VaxpMarkerWidget extends StatefulWidget {
  final Color color;
  final String? label;
  final bool isSelected;
  final VoidCallback? onTap;

  const VaxpMarkerWidget({
    super.key,
    this.color = const Color(0xFFFF5252),
    this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<VaxpMarkerWidget> createState() => _VaxpMarkerWidgetState();
}

class _VaxpMarkerWidgetState extends State<VaxpMarkerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: MapStyles.glassDecoration(
                opacity: 0.25,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.label!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (widget.label != null) const SizedBox(height: 2),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isSelected ? _pulseAnimation.value : 1.0,
                child: child,
              );
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
