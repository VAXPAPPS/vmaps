import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/map_styles.dart';

/// الشريط الجانبي
class Sidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          width: 60,
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 10, 10, 10),

          ),
          child: Column(
            children: [
              const SizedBox(height: 52), // مساحة للـ appbar
              _buildNavItem(0, Icons.map, 'الخريطة'),
              _buildNavItem(1, Icons.search, 'بحث'),
              _buildNavItem(2, Icons.route, 'مسارات'),
              _buildNavItem(3, Icons.favorite, 'مفضلة'),
              const Spacer(),
              _buildNavItem(4, Icons.settings, 'إعدادات'),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String tooltip) {
    final isSelected = widget.selectedIndex == index;

    return Tooltip(
      message: tooltip,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: () => widget.onItemSelected(index),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: MapStyles.routeColor.withOpacity(0.4))
                  : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? MapStyles.routeColor : Colors.white38,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
