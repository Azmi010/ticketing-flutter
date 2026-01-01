import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/models/event_model.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';

part 'curated_collections_event.dart';
part 'curated_collections_state.dart';

class CuratedCollectionsBloc extends Bloc<CuratedCollectionsEvent, CuratedCollectionsState> {
  CuratedCollectionsBloc({
    required this.eventRepository,
  }) : super(const CuratedCollectionsState()) {
    on<GetCuratedCollections>(_mapGetCuratedCollectionsEventToState);
  }
  final EventRepository eventRepository;

  void _mapGetCuratedCollectionsEventToState(
      GetCuratedCollections event, Emitter<CuratedCollectionsState> emit) async {
    emit(state.copyWith(status: CuratedCollectionsStatus.loading));
    try {
      final weekendEvents = await eventRepository.getWeekendEvents();
      final freeEvents = await eventRepository.getFreeEvents();
      
      emit(
        state.copyWith(
          status: CuratedCollectionsStatus.success,
          weekendEvents: weekendEvents,
          freeEvents: freeEvents,
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: CuratedCollectionsStatus.error));
    }
  }
}
