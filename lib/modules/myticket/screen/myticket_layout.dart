import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/core/constants/app_color.dart';
import '../widgets/events_by_status_widget/bloc/event_by_status_bloc.dart';
import '../widgets/events_by_status_widget/events_by_status_widget.dart';
import '../widgets/status_widget/chip_status.dart';

class MyTicketLayout extends StatefulWidget {
  const MyTicketLayout({super.key});

  @override
  State<MyTicketLayout> createState() => _MyTicketLayoutState();
}

class _MyTicketLayoutState extends State<MyTicketLayout> {
  String _selectedStatus = 'upcoming';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Tickets',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Status filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                ChipStatus(
                  label: 'Upcoming',
                  isSelected: _selectedStatus == 'upcoming',
                  onTap: () {
                    setState(() {
                      _selectedStatus = 'upcoming';
                    });
                    context.read<EventByStatusBloc>().add(
                          GetEventsByStatus('upcoming'),
                        );
                  },
                ),
                const SizedBox(width: 12),
                ChipStatus(
                  label: 'Past',
                  isSelected: _selectedStatus == 'past',
                  onTap: () {
                    setState(() {
                      _selectedStatus = 'past';
                    });
                    context.read<EventByStatusBloc>().add(
                          GetEventsByStatus('past'),
                        );
                  },
                ),
                const SizedBox(width: 12),
                ChipStatus(
                  label: 'Canceled',
                  isSelected: _selectedStatus == 'canceled',
                  onTap: () {
                    setState(() {
                      _selectedStatus = 'canceled';
                    });
                    context.read<EventByStatusBloc>().add(
                          GetEventsByStatus('canceled'),
                        );
                  },
                ),
              ],
            ),
          ),

          // Tickets list
          const Expanded(
            child: EventsByStatusWidget(),
          ),
        ],
      ),
    );
  }
}
