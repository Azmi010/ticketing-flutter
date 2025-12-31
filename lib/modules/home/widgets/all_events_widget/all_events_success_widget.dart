import 'package:flutter/material.dart';
import 'package:ticketing_flutter/data/models/event_model.dart';
import 'package:ticketing_flutter/modules/home/widgets/all_events_widget/all_events_item.dart';

class AllEventsSuccessWidget extends StatelessWidget {
  final List<Event> events;
  const AllEventsSuccessWidget({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const Text("No events found."),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final event = events[index];
        return AllEventsItem(event: event);
      },
    );
  }
}