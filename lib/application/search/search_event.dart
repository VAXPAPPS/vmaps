import 'package:equatable/equatable.dart';

/// أحداث البحث
abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

/// تغيير نص البحث (مع debounce)
class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

/// تنفيذ البحث
class SearchSubmitted extends SearchEvent {
  final String query;
  const SearchSubmitted(this.query);
  @override
  List<Object?> get props => [query];
}

/// مسح البحث
class ClearSearch extends SearchEvent {}
