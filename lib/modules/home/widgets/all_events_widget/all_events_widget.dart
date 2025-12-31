import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/modules/home/widgets/all_events_widget/all_events_success_widget.dart';
import 'package:ticketing_flutter/modules/home/widgets/all_events_widget/bloc/all_events_bloc.dart';

class AllEventsWidget extends StatelessWidget {
  const AllEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllEventsBloc, AllEventsState>(
      builder: (context, state) {
        if (state.status == EventStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == EventStatus.success) {
          return AllEventsSuccessWidget(events: state.events);
        } else if (state.status == EventStatus.error) {
          return const Center(child: Text("Error loading events"));
        }
        return const SizedBox();
      },
    );
  }
}
