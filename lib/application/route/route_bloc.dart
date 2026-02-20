import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/map_repository.dart';
import 'route_event.dart';
import 'route_state.dart';

/// BLoC المسارات - حساب المسار بين نقطتين
class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final MapRepository _repository;

  RouteBloc({required MapRepository repository})
      : _repository = repository,
        super(RouteInitial()) {
    on<SetOriginEvent>(_onSetOrigin);
    on<SetDestinationEvent>(_onSetDestination);
    on<CalculateRouteEvent>(_onCalculateRoute);
    on<ClearRouteEvent>(_onClearRoute);
  }

  void _onSetOrigin(SetOriginEvent event, Emitter<RouteState> emit) {
    if (state is RoutePointsSet) {
      final current = state as RoutePointsSet;
      emit(current.copyWith(origin: event.position, originName: event.name));
    } else {
      emit(RoutePointsSet(origin: event.position, originName: event.name));
    }
  }

  void _onSetDestination(SetDestinationEvent event, Emitter<RouteState> emit) {
    if (state is RoutePointsSet) {
      final current = state as RoutePointsSet;
      emit(current.copyWith(destination: event.position, destinationName: event.name));
    } else {
      emit(RoutePointsSet(destination: event.position, destinationName: event.name));
    }
  }

  Future<void> _onCalculateRoute(CalculateRouteEvent event, Emitter<RouteState> emit) async {
    if (state is RoutePointsSet) {
      final points = state as RoutePointsSet;
      if (points.origin == null || points.destination == null) return;

      emit(RouteCalculating());

      try {
        final route = await _repository.getRoute(
          points.origin!,
          points.destination!,
        );
        emit(RouteLoaded(route));
      } catch (e) {
        emit(RouteError('فشل حساب المسار: ${e.toString()}'));
      }
    }
  }

  void _onClearRoute(ClearRouteEvent event, Emitter<RouteState> emit) {
    emit(RouteInitial());
  }
}
