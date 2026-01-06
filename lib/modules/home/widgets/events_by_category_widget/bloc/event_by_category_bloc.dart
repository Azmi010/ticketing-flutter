import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ticketing_flutter/data/models/event_model.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';

part 'event_by_category_event.dart';
part 'event_by_category_state.dart';

class EventByCategoryBloc extends Bloc<EventByCategoryEvent, EventByCategoryState> {
  final EventRepository eventRepository;

  EventByCategoryBloc({required this.eventRepository}) : super(const EventByCategoryState()) {
    on<GetEventsByCategory>(_onGetEventsByCategory);
  }

  void _onGetEventsByCategory(GetEventsByCategory event, Emitter<EventByCategoryState> emit) async {
    emit(state.copyWith(status: EventStatus.loading));
    try {
      final allEvents = await eventRepository.getEvents();
      
      final filteredEvents = event.categoryId == 0 
          ? allEvents 
          : allEvents.where((e) => e.category?.id == event.categoryId).toList();

      emit(state.copyWith(
        status: EventStatus.success,
        events: filteredEvents,
      ));
    } catch (_) {
      emit(state.copyWith(status: EventStatus.error));
    }
  }
}