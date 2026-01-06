import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';
import 'event_admin_event.dart';
import 'event_admin_state.dart';

class EventAdminBloc extends Bloc<EventAdminEvent, EventAdminState> {
  final EventRepository eventRepository;

  EventAdminBloc({required this.eventRepository}) : super(EventAdminInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<CreateEvent>(_onCreateEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  Future<void> _onLoadEvents(
    LoadEvents event,
    Emitter<EventAdminState> emit,
  ) async {
    emit(EventAdminLoading());
    try {
      final events = await eventRepository.getEvents();
      emit(EventAdminLoaded(events));
    } catch (e) {
      emit(EventAdminError('Failed to load events: ${e.toString()}'));
    }
  }

  Future<void> _onCreateEvent(
    CreateEvent event,
    Emitter<EventAdminState> emit,
  ) async {
    emit(EventAdminLoading());
    try {
      await eventRepository.createEvent(
        title: event.title,
        description: event.description,
        location: event.location,
        date: event.date,
        categoryId: event.categoryId,
        organizerId: event.organizerId,
      );
      
      emit(EventAdminOperationSuccess('Event created successfully'));
      
      final events = await eventRepository.getEvents();
      emit(EventAdminLoaded(events));
    } catch (e) {
      emit(EventAdminError('Failed to create event: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateEvent(
    UpdateEvent event,
    Emitter<EventAdminState> emit,
  ) async {
    emit(EventAdminLoading());
    try {
      await eventRepository.updateEvent(
        id: event.id,
        title: event.title,
        description: event.description,
        location: event.location,
        date: event.date,
        categoryId: event.categoryId,
        organizerId: event.organizerId,
      );
      
      emit(EventAdminOperationSuccess('Event updated successfully'));
      
      final events = await eventRepository.getEvents();
      emit(EventAdminLoaded(events));
    } catch (e) {
      emit(EventAdminError('Failed to update event: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteEvent(
    DeleteEvent event,
    Emitter<EventAdminState> emit,
  ) async {
    emit(EventAdminLoading());
    try {
      await eventRepository.deleteEvent(event.id);
      
      emit(EventAdminOperationSuccess('Event deleted successfully'));
      
      final events = await eventRepository.getEvents();
      emit(EventAdminLoaded(events));
    } catch (e) {
      emit(EventAdminError('Failed to delete event: ${e.toString()}'));
    }
  }
}
