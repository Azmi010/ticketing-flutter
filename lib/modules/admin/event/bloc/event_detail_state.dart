import 'package:equatable/equatable.dart';
import 'package:ticketing_flutter/data/models/event_model.dart';

abstract class EventDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventDetailInitial extends EventDetailState {}

class EventDetailLoading extends EventDetailState {}

class EventDetailLoaded extends EventDetailState {
  final Event event;

  EventDetailLoaded(this.event);

  @override
  List<Object?> get props => [event];
}

class EventDetailOperationSuccess extends EventDetailState {
  final String message;

  EventDetailOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EventDetailError extends EventDetailState {
  final String message;

  EventDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
