part of 'search_bloc.dart';

class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  SearchQueryChanged({required this.query});
  final String query;

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends SearchEvent {}
