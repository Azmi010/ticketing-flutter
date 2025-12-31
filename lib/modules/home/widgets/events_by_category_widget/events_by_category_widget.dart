import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/modules/home/widgets/events_by_category_widget/bloc/event_by_category_bloc.dart';
import 'events_by_category_success_widget.dart';

class EventsByCategoryWidget extends StatelessWidget {
  const EventsByCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventByCategoryBloc, EventByCategoryState>(
      builder: (context, state) {
        if (state.status == EventStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == EventStatus.success) {
          return EventsByCategorySuccessWidget(events: state.events);
        } else if (state.status == EventStatus.error) {
          return const Center(child: Text("Error loading events"));
        }
        return const SizedBox();
      },
    );
  }
}