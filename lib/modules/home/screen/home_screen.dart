import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';
import 'package:ticketing_flutter/data/repositories/ticket_subscription_service.dart';
import 'package:ticketing_flutter/modules/home/screen/home_layout.dart';
import 'package:ticketing_flutter/modules/home/widgets/all_events_widget/bloc/all_events_bloc.dart';
import 'package:ticketing_flutter/modules/home/widgets/category_widget/bloc/category_bloc.dart';
import 'package:ticketing_flutter/modules/home/widgets/events_by_category_widget/bloc/event_by_category_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => EventRepository(),
        ),
        RepositoryProvider(
          create: (context) => TicketSubscriptionService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AllEventsBloc>(
            create: (context) => AllEventsBloc(
              eventRepository: context.read<EventRepository>(),
            )..add(GetAllEvents()),
          ),
          BlocProvider<CategoryBloc>(
            create: (context) =>
                CategoryBloc(eventRepository: context.read<EventRepository>())
                  ..add(GetCategories()),
          ),
          BlocProvider<EventByCategoryBloc>(
            create: (context) => EventByCategoryBloc(
              eventRepository: context.read<EventRepository>(),
              subscriptionService: context.read<TicketSubscriptionService>(),
            )..add(GetEventsByCategory(0)),
          ),
        ],
        child: HomeLayout(),
      ),
    );
  }
}
