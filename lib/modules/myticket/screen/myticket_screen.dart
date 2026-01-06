import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/order_repository.dart';
import '../widgets/events_by_status_widget/bloc/event_by_status_bloc.dart';
import 'myticket_layout.dart';

class MyTicketScreen extends StatelessWidget {
  const MyTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => OrderRepository(),
      child: BlocProvider(
        create: (context) => EventByStatusBloc(
          orderRepository: context.read<OrderRepository>(),
        )..add(GetEventsByStatus('upcoming')),
        child: const MyTicketLayout(),
      ),
    );
  }
}
