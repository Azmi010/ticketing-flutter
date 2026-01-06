part of 'event_by_status_bloc.dart';

enum OrderStatus { initial, loading, success, error }

class EventByStatusState extends Equatable {
  const EventByStatusState({
    this.status = OrderStatus.initial,
    this.orders = const [],
    this.errorMessage,
  });

  final List<Order> orders;
  final OrderStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, orders, errorMessage];

  EventByStatusState copyWith({
    List<Order>? orders,
    OrderStatus? status,
    String? errorMessage,
  }) {
    return EventByStatusState(
      orders: orders ?? this.orders,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
