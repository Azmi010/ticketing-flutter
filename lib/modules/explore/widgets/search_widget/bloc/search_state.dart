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
    this.location = '',
    this.categoryId,
    this.startDate,
    this.endDate,
    this.results = const [],
    this.errorMessage,
  });

  final SearchStatus status;
  final String query;
  final String location;
  final int? categoryId;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<SearchEventResponse> results;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        query,
        location,
        categoryId,
        startDate,
        endDate,
        results,
        errorMessage,
      ];

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    String? location,
    int? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    List<SearchEventResponse>? results,
    String? errorMessage,
    bool clearCategoryId = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      location: location ?? this.location,
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      results: results ?? this.results,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
