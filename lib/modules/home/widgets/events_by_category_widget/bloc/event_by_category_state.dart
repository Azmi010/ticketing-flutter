part of 'event_by_category_bloc.dart';

enum EventStatus { initial, loading, success, error }

class EventByCategoryState extends Equatable {
  const EventByCategoryState({
    this.status = EventStatus.initial,
    this.events = const [],
  });

  final List<Event> events;
  final EventStatus status;

  @override
  List<Object?> get props => [status, events];

  EventByCategoryState copyWith({
    List<Event>? events,
    EventStatus? status,
  }) {
    return EventByCategoryState(
      events: events ?? this.events,
      status: status ?? this.status,
    );
  }
}