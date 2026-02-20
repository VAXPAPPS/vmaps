import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/map_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

/// BLoC البحث - مع debounce للبحث الفوري
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MapRepository _repository;
  Timer? _debounceTimer;

  SearchBloc({required MapRepository repository})
      : _repository = repository,
        super(SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchSubmitted>(_onSubmitted);
    on<ClearSearch>(_onClear);
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();

    if (event.query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    // debounce 500ms
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      add(SearchSubmitted(event.query));
    });
  }

  Future<void> _onSubmitted(SearchSubmitted event, Emitter<SearchState> emit) async {
    if (event.query.trim().isEmpty) return;

    emit(SearchLoading());

    try {
      final results = await _repository.searchPlaces(event.query);
      emit(SearchLoaded(results: results, query: event.query));
    } catch (e) {
      emit(SearchError('فشل البحث: ${e.toString()}'));
    }
  }

  void _onClear(ClearSearch event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();
    emit(SearchInitial());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
