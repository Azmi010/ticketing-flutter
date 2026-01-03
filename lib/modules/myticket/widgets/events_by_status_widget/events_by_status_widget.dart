import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/modules/myticket/widgets/events_by_status_widget/bloc/event_by_status_bloc.dart';
import 'events_by_status_success.dart';

class EventsByStatusWidget extends StatelessWidget {
  const EventsByStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventByStatusBloc, EventByStatusState>(
      builder: (context, state) {
        if (state.status == TicketStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF5A4BE8),
            ),
          );
        } else if (state.status == TicketStatus.success) {
          return EventsByStatusSuccess(tickets: state.tickets);
        } else if (state.status == TicketStatus.error) {
          return const Center(
            child: Text("Error loading tickets"),
          );
        }
        return const SizedBox();
      },
    );
  }
}
