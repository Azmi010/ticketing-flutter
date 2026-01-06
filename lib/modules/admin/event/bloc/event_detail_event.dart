import 'package:equatable/equatable.dart';

abstract class EventDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEventDetail extends EventDetailEvent {
  final int eventId;

  LoadEventDetail(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class CreateTicket extends EventDetailEvent {
  final int eventId;
  final String name;
  final double price;
  final int quota;

  CreateTicket({
    required this.eventId,
    required this.name,
    required this.price,
    required this.quota,
  });

  @override
  List<Object?> get props => [eventId, name, price, quota];
}

class UpdateTicket extends EventDetailEvent {
  final int id;
  final String name;
  final double price;
  final int quota;

  UpdateTicket({
    required this.id,
    required this.name,
    required this.price,
    required this.quota,
  });

  @override
  List<Object?> get props => [id, name, price, quota];
}

class DeleteTicket extends EventDetailEvent {
  final int id;

  DeleteTicket(this.id);

  @override
  List<Object?> get props => [id];
}
