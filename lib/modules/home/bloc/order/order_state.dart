import 'package:equatable/equatable.dart';
import 'package:ticketing_flutter/data/models/order_model.dart';

abstract class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final Order order;

  OrderSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);

  @override
  List<Object?> get props => [message];
}
