import 'package:equatable/equatable.dart';
import 'package:ticketing_flutter/data/models/event_model.dart';

abstract class EventAdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventAdminInitial extends EventAdminState {}

class EventAdminLoading extends EventAdminState {}

class EventAdminLoaded extends EventAdminState {
  final List<Event> events;

  EventAdminLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class EventAdminError extends EventAdminState {
  final String message;

  EventAdminError(this.message);

  @override
  List<Object?> get props => [message];
}

class EventAdminOperationSuccess extends EventAdminState {
  final String message;

  EventAdminOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
