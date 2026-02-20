/// ثوابت الخريطة - روابط الخرائط والإعدادات الافتراضية
class MapConstants {
  MapConstants._();

  /// طبقات الخريطة المتاحة
  static const List<MapLayerConfig> layers = [
    MapLayerConfig(
      name: 'عادية',
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      attribution: '© OpenStreetMap contributors',
      icon: 'map',
    ),
    MapLayerConfig(
      name: 'داكنة',
      urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
      attribution: '© CartoDB',
      subdomains: ['a', 'b', 'c', 'd'],
      icon: 'dark_mode',
    ),
    MapLayerConfig(
      name: 'طبوغرافية',
      urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
      attribution: '© OpenTopoMap',
      subdomains: ['a', 'b', 'c'],
      icon: 'terrain',
    ),
    MapLayerConfig(
      name: 'إنسانية',
      urlTemplate: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
      attribution: '© Humanitarian OSM',
      subdomains: ['a', 'b'],
      icon: 'favorite',
    ),
  ];

  /// الإعدادات الافتراضية
  static const double defaultZoom = 6.0;
  static const double minZoom = 2.0;
  static const double maxZoom = 18.0;

  /// الموقع الافتراضي (الرياض)
  static const double defaultLat = 24.7136;
  static const double defaultLng = 46.6753;
}

/// تكوين طبقة خريطة
class MapLayerConfig {
  final String name;
  final String urlTemplate;
  final String attribution;
  final List<String> subdomains;
  final String icon;

  const MapLayerConfig({
    required this.name,
    required this.urlTemplate,
    required this.attribution,
    this.subdomains = const [],
    required this.icon,
  });
}
