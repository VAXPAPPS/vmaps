import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// كيان المكان - يمثل أي نقطة جغرافية على الخريطة
class PlaceEntity extends Equatable {
  final String id;
  final String name;
  final String displayName;
  final LatLng position;
  final String? type;
  final String? category;
  final bool isFavorite;

  const PlaceEntity({
    required this.id,
    required this.name,
    required this.displayName,
    required this.position,
    this.type,
    this.category,
    this.isFavorite = false,
  });

  PlaceEntity copyWith({
    String? id,
    String? name,
    String? displayName,
    LatLng? position,
    String? type,
    String? category,
    bool? isFavorite,
  }) {
    return PlaceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      position: position ?? this.position,
      type: type ?? this.type,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, name, displayName, position, type, category, isFavorite];
}
