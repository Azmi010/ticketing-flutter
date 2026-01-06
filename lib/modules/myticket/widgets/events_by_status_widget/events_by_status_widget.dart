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
        if (state.status == OrderStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF5A4BE8),
            ),
          );
        } else if (state.status == OrderStatus.success) {
          return EventsByStatusSuccess(orders: state.orders);
        } else if (state.status == OrderStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Error loading orders",
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 8),
                if (state.errorMessage != null)
                  Text(
                    state.errorMessage!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
