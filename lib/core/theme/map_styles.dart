import 'package:flutter/material.dart';

/// أنماط خاصة بعناصر الخريطة
class MapStyles {
  MapStyles._();

  /// لون المسار
  static const Color routeColor = Color(0xFF4FC3F7);
  static const Color routeOutlineColor = Color(0xFF0288D1);
  static const double routeWidth = 5.0;

  /// لون العلامات
  static const Color markerColor = Color(0xFFFF5252);
  static const Color markerGlow = Color(0x66FF5252);
  static const Color originMarkerColor = Color(0xFF4CAF50);
  static const Color destinationMarkerColor = Color(0xFFF44336);

  /// ألوان لوحات الواجهة الزجاجية
  static const Color panelBackground = Color(0xCC1A1A2E);
  static const Color panelBorder = Color(0x33FFFFFF);
  static const Color searchBarBackground = Color(0x4D1A1A2E);

  /// ألوان أزرار التحكم
  static const Color controlButtonBg = Color(0xCC1A1A2E);
  static const Color controlButtonHover = Color(0xFF2A2A4E);

  /// ظل العناصر الزجاجية
  static List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  /// تزيين الزجاج
  static BoxDecoration glassDecoration({
    double opacity = 0.15,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: Colors.white.withOpacity(opacity),
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      border: Border.all(color: panelBorder),
      boxShadow: glassShadow,
    );
  }
}
