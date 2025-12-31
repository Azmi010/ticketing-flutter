part of 'all_events_bloc.dart';

abstract class AllEventsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllEvents extends AllEventsEvent {
  GetAllEvents();

  @override
  List<Object?> get props => [];
}