import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ticketing_flutter/data/models/order_model.dart';
import 'package:ticketing_flutter/data/repositories/order_repository.dart';

part 'event_by_status_event.dart';
part 'event_by_status_state.dart';

class EventByStatusBloc extends Bloc<EventByStatusEvent, EventByStatusState> {
  final OrderRepository orderRepository;

  EventByStatusBloc({required this.orderRepository})
      : super(const EventByStatusState()) {
    on<GetEventsByStatus>(_onGetEventsByStatus);
  }

  void _onGetEventsByStatus(
    GetEventsByStatus event,
    Emitter<EventByStatusState> emit,
  ) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final orders = await orderRepository.getMyOrders();
      
      final filteredOrders = _filterOrdersByStatus(orders, event.status);
      
      emit(state.copyWith(
        status: OrderStatus.success,
        orders: filteredOrders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  List<Order> _filterOrdersByStatus(List<Order> orders, String status) {
    final now = DateTime.now();
    
    switch (status) {
      case 'upcoming':
        return orders.where((order) {
          if (order.details == null || order.details!.isEmpty) return false;
          final eventDate = order.details!.first.ticket?.event?.date;
          return eventDate != null && eventDate.isAfter(now);
        }).toList();
      
      case 'past':
        return orders.where((order) {
          if (order.details == null || order.details!.isEmpty) return false;
          final eventDate = order.details!.first.ticket?.event?.date;
          return eventDate != null && eventDate.isBefore(now);
        }).toList();
      
      case 'canceled':
        return [];
      
      default:
        return orders;
    }
  }
}
