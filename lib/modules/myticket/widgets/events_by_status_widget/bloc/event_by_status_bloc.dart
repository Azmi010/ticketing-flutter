import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ticketing_flutter/data/models/ticket_model.dart';
import 'package:ticketing_flutter/data/repositories/ticket_repository.dart';

part 'event_by_status_event.dart';
part 'event_by_status_state.dart';

class EventByStatusBloc extends Bloc<EventByStatusEvent, EventByStatusState> {
  final TicketRepository ticketRepository;

  EventByStatusBloc({required this.ticketRepository})
      : super(const EventByStatusState()) {
    on<GetEventsByStatus>(_onGetEventsByStatus);
  }

  void _onGetEventsByStatus(
    GetEventsByStatus event,
    Emitter<EventByStatusState> emit,
  ) async {
    emit(state.copyWith(status: TicketStatus.loading));
    try {
      final tickets = await ticketRepository.getTicketsByStatus(event.status);
      emit(state.copyWith(
        status: TicketStatus.success,
        tickets: tickets,
      ));
    } catch (_) {
      emit(state.copyWith(status: TicketStatus.error));
    }
  }
}
