import 'package:flutter/material.dart';
import 'package:ticketing_flutter/data/models/event_model.dart';
import 'package:ticketing_flutter/modules/home/widgets/events_by_category_widget/event_by_category_card.dart';

class EventsByCategorySuccessWidget extends StatelessWidget {
  final List<Event> events;
  
  const EventsByCategorySuccessWidget({
    super.key, 
    required this.events
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const Text("No events found."),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      scrollDirection: Axis.horizontal,
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventByCategoryCard(event: event);
      },
    );
  }
}