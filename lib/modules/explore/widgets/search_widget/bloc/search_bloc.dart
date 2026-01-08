import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';
import 'package:ticketing_flutter/data/models/search_event_input_model.dart';
import 'package:ticketing_flutter/data/models/search_event_response_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final EventRepository eventRepository;

  SearchBloc({required this.eventRepository}) : super(const SearchState()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchLocationChanged>(_onSearchLocationChanged);
    on<SearchCategoryChanged>(_onSearchCategoryChanged);
    on<SearchDateRangeChanged>(_onSearchDateRangeChanged);
    on<PerformSearch>(_onPerformSearch);
    on<ClearSearch>(_onClearSearch);
  }

  void _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(state.copyWith(query: event.query));
    
    // Auto-search after a short delay
    await Future.delayed(const Duration(milliseconds: 500));
    if (event.query.isNotEmpty || _hasActiveFilters()) {
      add(PerformSearch());
    } else {
      emit(state.copyWith(status: SearchStatus.initial, results: []));
    }
  }

  void _onSearchLocationChanged(
      SearchLocationChanged event, Emitter<SearchState> emit) async {
    emit(state.copyWith(location: event.location));
    if (event.location.isNotEmpty || state.query.isNotEmpty || _hasActiveFilters()) {
      add(PerformSearch());
    }
  }

  void _onSearchCategoryChanged(
      SearchCategoryChanged event, Emitter<SearchState> emit) async {
    emit(state.copyWith(
      categoryId: event.categoryId,
      clearCategoryId: event.categoryId == null,
    ));
    if (event.categoryId != null || state.query.isNotEmpty || _hasActiveFilters()) {
      add(PerformSearch());
    }
  }

  void _onSearchDateRangeChanged(
      SearchDateRangeChanged event, Emitter<SearchState> emit) async {
    emit(state.copyWith(
      startDate: event.startDate,
      endDate: event.endDate,
      clearStartDate: event.startDate == null,
      clearEndDate: event.endDate == null,
    ));
    if (event.startDate != null || event.endDate != null || 
        state.query.isNotEmpty || _hasActiveFilters()) {
      add(PerformSearch());
    }
  }

  void _onPerformSearch(
      PerformSearch event, Emitter<SearchState> emit) async {
    // Don't search if all fields are empty
    if (state.query.isEmpty && 
        state.location.isEmpty && 
        state.categoryId == null && 
        state.startDate == null && 
        state.endDate == null) {
      emit(state.copyWith(status: SearchStatus.initial, results: []));
      return;
    }

    emit(state.copyWith(status: SearchStatus.searching));
    
    try {
      final searchInput = SearchEventInput(
        keyword: state.query.isNotEmpty ? state.query : null,
        location: state.location.isNotEmpty ? state.location : null,
        categoryId: state.categoryId,
        startDate: state.startDate,
        endDate: state.endDate,
      );

      final results = await eventRepository.searchEvents(searchInput);
      
      emit(state.copyWith(
        status: SearchStatus.success,
        results: results,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: e.toString(),
        results: [],
      ));
    }
  }

  void _onClearSearch(
      ClearSearch event, Emitter<SearchState> emit) async {
    emit(const SearchState());
  }

  bool _hasActiveFilters() {
    return state.location.isNotEmpty || 
           state.categoryId != null || 
           state.startDate != null || 
           state.endDate != null;
  }
}
