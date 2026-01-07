import 'package:equatable/equatable.dart';
import 'package:ticketing_flutter/data/models/order_model.dart';

abstract class OrderAdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderAdminInitial extends OrderAdminState {}

class OrderAdminLoading extends OrderAdminState {}

class OrderAdminLoaded extends OrderAdminState {
  final List<Order> orders;
  final List<Order> filteredOrders;
  final DateTime? startDate;
  final DateTime? endDate;

  OrderAdminLoaded({
    required this.orders,
    required this.filteredOrders,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [orders, filteredOrders, startDate, endDate];

  OrderAdminLoaded copyWith({
    List<Order>? orders,
    List<Order>? filteredOrders,
    DateTime? startDate,
    DateTime? endDate,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return OrderAdminLoaded(
      orders: orders ?? this.orders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
    );
  }
}

class OrderAdminError extends OrderAdminState {
  final String message;

  OrderAdminError(this.message);

  @override
  List<Object?> get props => [message];
}
