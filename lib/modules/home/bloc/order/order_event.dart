import 'package:equatable/equatable.dart';
import 'package:ticketing_flutter/data/models/order_input_model.dart';
import 'package:ticketing_flutter/data/models/email_status_model.dart';
import 'package:ticketing_flutter/data/models/order_model.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateOrder extends OrderEvent {
  final List<OrderInput> items;

  CreateOrder(this.items);

  @override
  List<Object?> get props => [items];
}

class CreateOrderSuccess extends OrderEvent {
  final Order order;

  CreateOrderSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class SubscribeToEmailStatus extends OrderEvent {
  final int orderId;

  SubscribeToEmailStatus(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class EmailStatusReceived extends OrderEvent {
  final EmailStatusUpdate update;

  EmailStatusReceived(this.update);

  @override
  List<Object?> get props => [update];
}

class UnsubscribeEmailStatus extends OrderEvent {}
