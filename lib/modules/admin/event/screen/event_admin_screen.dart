import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/core/constants/app_color.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';
import 'package:ticketing_flutter/modules/admin/event/bloc/event_admin_bloc.dart';
import 'package:ticketing_flutter/modules/admin/event/bloc/event_admin_event.dart';
import 'package:ticketing_flutter/modules/admin/event/bloc/event_admin_state.dart';
import 'package:ticketing_flutter/modules/admin/event/screen/event_detail_screen.dart';
import 'package:ticketing_flutter/modules/auth/bloc/auth_bloc.dart';
import 'package:ticketing_flutter/modules/auth/bloc/auth_state.dart';
import 'package:intl/intl.dart';

class EventAdminScreen extends StatelessWidget {
  const EventAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EventAdminBloc(eventRepository: EventRepository())..add(LoadEvents()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Manage Events',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<EventAdminBloc, EventAdminState>(
          listener: (context, state) {
            if (state is EventAdminOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is EventAdminError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is EventAdminLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EventAdminError && state is! EventAdminLoaded) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<EventAdminBloc>().add(LoadEvents());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is EventAdminLoaded ||
                state is EventAdminOperationSuccess) {
              // Reload events after operation success
              if (state is EventAdminOperationSuccess) {
                Future.microtask(
                  () => context.read<EventAdminBloc>().add(LoadEvents()),
                );
                return const Center(child: CircularProgressIndicator());
              }

              final eventList = (state as EventAdminLoaded).events;

              return Column(
                children: [
                  Expanded(
                    child: eventList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 80,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No events yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              context.read<EventAdminBloc>().add(LoadEvents());
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: eventList.length,
                              itemBuilder: (listContext, index) {
                                final event = eventList[index];
                                return _EventCard(
                                  event: event,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventDetailScreen(eventId: event.id),
                                      ),
                                    );
                                  },
                                  onEdit: () {
                                    _showEventDialog(listContext, event: event);
                                  },
                                  onDelete: () {
                                    _showDeleteDialog(listContext, event.id);
                                  },
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
        floatingActionButton: Builder(
          builder: (builderContext) => FloatingActionButton.extended(
            onPressed: () {
              _showEventDialog(builderContext);
            },
            backgroundColor: AppColors.primary,
            icon: Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Create Event',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _showEventDialog(BuildContext context, {dynamic event}) {
    final titleController = TextEditingController(text: event?.title ?? '');
    final descController = TextEditingController(
      text: event?.description ?? '',
    );
    final locationController = TextEditingController(
      text: event?.location ?? '',
    );

    // Get current user ID from AuthBloc
    final authState = context.read<AuthBloc>().state;
    int organizerId = 1; // Default organizer ID
    if (authState is AuthSuccess) {
      organizerId = int.parse(authState.user.id);
    }

    // Capture bloc reference before showing dialog
    final eventBloc = context.read<EventAdminBloc>();
    final eventRepository = EventRepository();

    showDialog(
      context: context,
      builder: (dialogContext) => _EventDialog(
        event: event,
        titleController: titleController,
        descController: descController,
        locationController: locationController,
        organizerId: organizerId,
        eventBloc: eventBloc,
        eventRepository: eventRepository,
      ),
    );
  }
}

class _EventDialog extends StatefulWidget {
  final dynamic event;
  final TextEditingController titleController;
  final TextEditingController descController;
  final TextEditingController locationController;
  final int organizerId;
  final EventAdminBloc eventBloc;
  final EventRepository eventRepository;

  const _EventDialog({
    required this.event,
    required this.titleController,
    required this.descController,
    required this.locationController,
    required this.organizerId,
    required this.eventBloc,
    required this.eventRepository,
  });

  @override
  State<_EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<_EventDialog> {
  late DateTime selectedDate;
  late int selectedCategory;
  List<dynamic> categories = [];
  bool isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.event?.date ?? DateTime.now();
    selectedCategory = widget.event?.category?.id ?? 1;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final loadedCategories = await widget.eventRepository.getCategories();
      setState(() {
        categories = loadedCategories;
        isLoadingCategories = false;
        if (categories.isNotEmpty &&
            selectedCategory == 1 &&
            widget.event == null) {
          selectedCategory = categories.first.id;
        }
      });
    } catch (e) {
      setState(() {
        isLoadingCategories = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load categories: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );

      if (timePicked != null) {
        setState(() {
          selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.event == null ? 'Create Event' : 'Edit Event'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widget.titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: widget.descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: widget.locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date & Time',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  DateFormat('MMM dd, yyyy • HH:mm').format(selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            isLoadingCategories
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<int>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                  ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.event == null) {
              widget.eventBloc.add(
                CreateEvent(
                  title: widget.titleController.text,
                  description: widget.descController.text,
                  date: selectedDate,
                  location: widget.locationController.text,
                  categoryId: selectedCategory,
                  organizerId: widget.organizerId,
                ),
              );
            } else {
              widget.eventBloc.add(
                UpdateEvent(
                  id: widget.event.id,
                  title: widget.titleController.text,
                  description: widget.descController.text,
                  date: selectedDate,
                  location: widget.locationController.text,
                  categoryId: selectedCategory,
                  organizerId: widget.event.organizer?.id ?? widget.organizerId,
                ),
              );
            }
            Navigator.pop(context);
          },
          child: Text(widget.event == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }
}

void _showDeleteDialog(BuildContext context, int eventId) {
  // Capture bloc reference before showing dialog
  final eventBloc = context.read<EventAdminBloc>();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete Event'),
      content: const Text('Are you sure you want to delete this event?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            eventBloc.add(DeleteEvent(eventId));
            Navigator.pop(dialogContext);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}

class _EventCard extends StatelessWidget {
  final dynamic event;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EventCard({
    required this.event,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            event.description,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.location,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                DateFormat('MMM dd, yyyy • HH:mm').format(event.date),
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          if (event.category != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                event.category!.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    ),
    );
  }
}
