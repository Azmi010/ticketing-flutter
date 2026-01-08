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

class SearchLocationChanged extends SearchEvent {
  SearchLocationChanged({required this.location});
  final String location;

  @override
  List<Object?> get props => [location];
}

class SearchCategoryChanged extends SearchEvent {
  SearchCategoryChanged({required this.categoryId});
  final int? categoryId;

  @override
  List<Object?> get props => [categoryId];
}

class SearchDateRangeChanged extends SearchEvent {
  SearchDateRangeChanged({this.startDate, this.endDate});
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

class PerformSearch extends SearchEvent {}

class ClearSearch extends SearchEvent {}
