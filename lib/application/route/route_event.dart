import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// أحداث المسار
abstract class RouteEvent extends Equatable {
  const RouteEvent();
  @override
  List<Object?> get props => [];
}

/// تعيين نقطة البداية
class SetOriginEvent extends RouteEvent {
  final LatLng position;
  final String? name;
  const SetOriginEvent(this.position, {this.name});
  @override
  List<Object?> get props => [position, name];
}

/// تعيين نقطة الوجهة
class SetDestinationEvent extends RouteEvent {
  final LatLng position;
  final String? name;
  const SetDestinationEvent(this.position, {this.name});
  @override
  List<Object?> get props => [position, name];
}

/// حساب المسار
class CalculateRouteEvent extends RouteEvent {}

/// مسح المسار
class ClearRouteEvent extends RouteEvent {}
