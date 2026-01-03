import 'package:flutter/material.dart';
import '../../../../data/models/ticket_model.dart';
import 'events_by_status_card.dart';

class EventsByStatusSuccess extends StatelessWidget {
  final List<Ticket> tickets;

  const EventsByStatusSuccess({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tickets found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        return EventsByStatusCard(ticket: tickets[index]);
      },
    );
  }
}
