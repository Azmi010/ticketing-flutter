part of 'search_bloc.dart';

enum SearchStatus { initial, searching, success, error }

extension SearchStatusX on SearchStatus {
  bool get isInitial => this == SearchStatus.initial;
  bool get isSearching => this == SearchStatus.searching;
  bool get isSuccess => this == SearchStatus.success;
  bool get isError => this == SearchStatus.error;
}

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
  });

  final SearchStatus status;
  final String query;

  @override
  List<Object?> get props => [status, query];

  SearchState copyWith({
    SearchStatus? status,
    String? query,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
    );
  }
}
