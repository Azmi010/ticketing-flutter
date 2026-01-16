import 'package:equatable/equatable.dart';
import 'package:ticketing_flutter/data/models/order_model.dart';
import 'package:ticketing_flutter/data/models/email_status_model.dart';

abstract class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final Order order;
  final EmailStatusUpdate? emailStatus;

  OrderSuccess(this.order, {this.emailStatus});

  @override
  List<Object?> get props => [order, emailStatus];

  OrderSuccess copyWith({
    Order? order,
    EmailStatusUpdate? emailStatus,
  }) {
    return OrderSuccess(
      order ?? this.order,
      emailStatus: emailStatus ?? this.emailStatus,
    );
  }
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);

  @override
  List<Object?> get props => [message];
}
