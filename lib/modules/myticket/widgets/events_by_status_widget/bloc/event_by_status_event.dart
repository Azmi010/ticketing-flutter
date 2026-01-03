part of 'event_by_status_bloc.dart';

abstract class EventByStatusEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetEventsByStatus extends EventByStatusEvent {
  final String status;
  
  GetEventsByStatus(this.status);

  @override
  List<Object?> get props => [status];
}
