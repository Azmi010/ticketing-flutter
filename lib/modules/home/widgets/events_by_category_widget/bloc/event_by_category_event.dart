part of 'event_by_category_bloc.dart';

abstract class EventByCategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetEventsByCategory extends EventByCategoryEvent {
  final int categoryId;
  GetEventsByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class SubscribeToTicketUpdates extends EventByCategoryEvent {}

class UpdateTicketStock extends EventByCategoryEvent {
  final int eventId;
  final int ticketId;
  final int newStock;
  
  UpdateTicketStock({
    required this.eventId,
    required this.ticketId,
    required this.newStock,
  });

  @override
  List<Object?> get props => [eventId, ticketId, newStock];
}

class UnsubscribeFromTicketUpdates extends EventByCategoryEvent {}