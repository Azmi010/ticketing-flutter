part of 'all_events_bloc.dart';

enum EventStatus { initial, loading, success, error }

class AllEventsState extends Equatable {
  const AllEventsState({
    this.status = EventStatus.initial,
    this.events = const [],
  });

  final List<Event> events;
  final EventStatus status;

  @override
  List<Object?> get props => [status, events];

  AllEventsState copyWith({
    List<Event>? events,
    EventStatus? status,
  }) {
    return AllEventsState(
      events: events ?? this.events,
      status: status ?? this.status,
    );
  }
}