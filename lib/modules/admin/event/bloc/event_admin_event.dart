import 'package:equatable/equatable.dart';

abstract class EventAdminEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventAdminEvent {}

class CreateEvent extends EventAdminEvent {
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final int categoryId;
  final int organizerId;

  CreateEvent({
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.categoryId,
    required this.organizerId,
  });

  @override
  List<Object?> get props => [title, description, date, location, categoryId, organizerId];
}

class UpdateEvent extends EventAdminEvent {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final int categoryId;
  final int organizerId;

  UpdateEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.categoryId,
    required this.organizerId,
  });

  @override
  List<Object?> get props => [id, title, description, date, location, categoryId, organizerId];
}

class DeleteEvent extends EventAdminEvent {
  final int id;

  DeleteEvent(this.id);

  @override
  List<Object?> get props => [id];
}
