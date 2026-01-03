part of 'event_by_status_bloc.dart';

enum TicketStatus { initial, loading, success, error }

class EventByStatusState extends Equatable {
  const EventByStatusState({
    this.status = TicketStatus.initial,
    this.tickets = const [],
  });

  final List<Ticket> tickets;
  final TicketStatus status;

  @override
  List<Object?> get props => [status, tickets];

  EventByStatusState copyWith({
    List<Ticket>? tickets,
    TicketStatus? status,
  }) {
    return EventByStatusState(
      tickets: tickets ?? this.tickets,
      status: status ?? this.status,
    );
  }
}
