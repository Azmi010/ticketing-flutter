import 'package:equatable/equatable.dart';
import 'package:ticketing_flutter/data/models/order_input_model.dart';

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
