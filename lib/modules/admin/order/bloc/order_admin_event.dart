import 'package:equatable/equatable.dart';

abstract class OrderAdminEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrderAdminEvent {}

class FilterOrders extends OrderAdminEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  FilterOrders({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}
