import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ticketing_flutter/data/models/event_model.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';

part 'all_events_event.dart';
part 'all_events_state.dart';

class AllEventsBloc extends Bloc<AllEventsEvent, AllEventsState> {
  final EventRepository eventRepository;

  AllEventsBloc({required this.eventRepository}) : super(const AllEventsState()) {
    on<GetAllEvents>(_onGetAllEvents);
  }

  void _onGetAllEvents(GetAllEvents event, Emitter<AllEventsState> emit) async {
    emit(state.copyWith(status: EventStatus.loading));
    try {
      final allEvents = await eventRepository.getEvents();

      emit(state.copyWith(
        status: EventStatus.success,
        events: allEvents,
      ));
    } catch (_) {
      emit(state.copyWith(status: EventStatus.error));
    }
  }
}