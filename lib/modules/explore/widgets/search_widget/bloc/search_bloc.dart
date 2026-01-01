import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<SearchQueryChanged>(_mapSearchQueryChangedEventToState);
    on<ClearSearch>(_mapClearSearchEventToState);
  }

  void _mapSearchQueryChangedEventToState(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(state.copyWith(
      query: event.query,
      status: event.query.isEmpty 
          ? SearchStatus.initial 
          : SearchStatus.searching,
    ));
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (event.query.isNotEmpty) {
      emit(state.copyWith(status: SearchStatus.success));
    }
  }

  void _mapClearSearchEventToState(
      ClearSearch event, Emitter<SearchState> emit) async {
    emit(const SearchState());
  }
}
