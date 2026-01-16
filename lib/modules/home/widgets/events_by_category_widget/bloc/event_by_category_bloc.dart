import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ticketing_flutter/data/models/event_model.dart';
import 'package:ticketing_flutter/data/models/ticket_type_model.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';
import 'package:ticketing_flutter/data/repositories/ticket_subscription_service.dart';

part 'event_by_category_event.dart';
part 'event_by_category_state.dart';

class EventByCategoryBloc extends Bloc<EventByCategoryEvent, EventByCategoryState> {
  final EventRepository eventRepository;
  final TicketSubscriptionService subscriptionService;
  StreamSubscription? _ticketSubscription;

  EventByCategoryBloc({
    required this.eventRepository,
    required this.subscriptionService,
  }) : super(const EventByCategoryState()) {
    on<GetEventsByCategory>(_onGetEventsByCategory);
    on<SubscribeToTicketUpdates>(_onSubscribeToTicketUpdates);
    on<UpdateTicketStock>(_onUpdateTicketStock);
    on<UnsubscribeFromTicketUpdates>(_onUnsubscribeFromTicketUpdates);
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
      
      add(SubscribeToTicketUpdates());
    } catch (_) {
      emit(state.copyWith(status: EventStatus.error));
    }
  }
  
  void _onSubscribeToTicketUpdates(
    SubscribeToTicketUpdates event, 
    Emitter<EventByCategoryState> emit
  ) async {
    try {
      await subscriptionService.initialize();
      subscriptionService.subscribeToAllTickets();
      
      _ticketSubscription = subscriptionService.stockUpdates.listen((update) {
        add(UpdateTicketStock(
          eventId: update.eventId,
          ticketId: update.ticketId,
          newStock: update.remainingStock,
        ));
      });
      
      if (kDebugMode) {
        print('✅ Successfully subscribed to ticket updates');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to subscribe to ticket updates: $e');
        print('📱 App will continue to work, but without real-time updates');
      }
    }
  }
  
  void _onUpdateTicketStock(
    UpdateTicketStock event, 
    Emitter<EventByCategoryState> emit
  ) {
    final List<Event> updatedEvents = [];
    
    for (var ev in state.events) {
      if (ev.id == event.eventId) {
        final List<TicketType>? updatedTickets = ev.tickets != null
            ? []
            : null;
        
        if (ev.tickets != null) {
          for (var ticket in ev.tickets!) {
            if (ticket.id == event.ticketId) {
              updatedTickets!.add(TicketType(
                id: ticket.id,
                name: ticket.name,
                price: ticket.price,
                quota: event.newStock,
                eventId: ticket.eventId,
                event: ticket.event,
              ));
            } else {
              updatedTickets!.add(ticket);
            }
          }
        }
        
        final newTotalTickets = updatedTickets?.fold(
          0, 
          (int sum, ticket) => sum + ticket.quota
        ) ?? 0;
        
        updatedEvents.add(ev.copyWith(
          tickets: updatedTickets,
          totalTickets: newTotalTickets,
        ));
      } else {
        updatedEvents.add(ev);
      }
    }
    
    emit(state.copyWith(events: updatedEvents));
  }
  
  void _onUnsubscribeFromTicketUpdates(
    UnsubscribeFromTicketUpdates event, 
    Emitter<EventByCategoryState> emit
  ) {
    _ticketSubscription?.cancel();
    subscriptionService.unsubscribe();
  }
  
  @override
  Future<void> close() {
    _ticketSubscription?.cancel();
    subscriptionService.dispose();
    return super.close();
  }
}