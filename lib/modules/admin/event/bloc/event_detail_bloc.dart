import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';
import 'package:ticketing_flutter/data/repositories/ticket_type_repository.dart';
import 'event_detail_event.dart';
import 'event_detail_state.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final EventRepository eventRepository;
  final TicketTypeRepository ticketRepository;

  EventDetailBloc({
    required this.eventRepository,
    required this.ticketRepository,
  }) : super(EventDetailInitial()) {
    on<LoadEventDetail>(_onLoadEventDetail);
    on<CreateTicket>(_onCreateTicket);
    on<UpdateTicket>(_onUpdateTicket);
    on<DeleteTicket>(_onDeleteTicket);
  }

  Future<void> _onLoadEventDetail(
    LoadEventDetail event,
    Emitter<EventDetailState> emit,
  ) async {
    emit(EventDetailLoading());
    try {
      final eventData = await eventRepository.getEvent(event.eventId);
      emit(EventDetailLoaded(eventData));
    } catch (e) {
      emit(EventDetailError('Failed to load event: ${e.toString()}'));
    }
  }

  Future<void> _onCreateTicket(
    CreateTicket event,
    Emitter<EventDetailState> emit,
  ) async {
    emit(EventDetailLoading());
    try {
      await ticketRepository.createTicket(
        eventId: event.eventId,
        name: event.name,
        price: event.price,
        quota: event.quota,
      );
      
      emit(EventDetailOperationSuccess('Ticket created successfully'));
    } catch (e) {
      emit(EventDetailError('Failed to create ticket: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateTicket(
    UpdateTicket event,
    Emitter<EventDetailState> emit,
  ) async {
    emit(EventDetailLoading());
    try {
      await ticketRepository.updateTicket(
        id: event.id,
        name: event.name,
        price: event.price,
        quota: event.quota,
      );
      
      emit(EventDetailOperationSuccess('Ticket updated successfully'));
    } catch (e) {
      emit(EventDetailError('Failed to update ticket: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteTicket(
    DeleteTicket event,
    Emitter<EventDetailState> emit,
  ) async {
    emit(EventDetailLoading());
    try {
      await ticketRepository.deleteTicket(event.id);
      
      emit(EventDetailOperationSuccess('Ticket deleted successfully'));
    } catch (e) {
      emit(EventDetailError('Failed to delete ticket: ${e.toString()}'));
    }
  }
}
