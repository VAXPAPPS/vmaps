import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/route_entity.dart';

/// حالات المسار
abstract class RouteState extends Equatable {
  const RouteState();
  @override
  List<Object?> get props => [];
}

class RouteInitial extends RouteState {}

class RoutePointsSet extends RouteState {
  final LatLng? origin;
  final String? originName;
  final LatLng? destination;
  final String? destinationName;

  const RoutePointsSet({
    this.origin,
    this.originName,
    this.destination,
    this.destinationName,
  });

  RoutePointsSet copyWith({
    LatLng? origin,
    String? originName,
    LatLng? destination,
    String? destinationName,
  }) {
    return RoutePointsSet(
      origin: origin ?? this.origin,
      originName: originName ?? this.originName,
      destination: destination ?? this.destination,
      destinationName: destinationName ?? this.destinationName,
    );
  }

  @override
  List<Object?> get props => [origin, originName, destination, destinationName];
}

class RouteCalculating extends RouteState {}

class RouteLoaded extends RouteState {
  final RouteEntity route;

  const RouteLoaded(this.route);

  @override
  List<Object?> get props => [route];
}

class RouteError extends RouteState {
  final String message;
  const RouteError(this.message);
  @override
  List<Object?> get props => [message];
}
