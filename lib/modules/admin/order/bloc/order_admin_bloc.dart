import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/models/order_model.dart';
import 'package:ticketing_flutter/data/repositories/order_repository.dart';
import 'order_admin_event.dart';
import 'order_admin_state.dart';

class OrderAdminBloc extends Bloc<OrderAdminEvent, OrderAdminState> {
  final OrderRepository orderRepository;

  OrderAdminBloc({required this.orderRepository}) : super(OrderAdminInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<FilterOrders>(_onFilterOrders);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrderAdminState> emit,
  ) async {
    emit(OrderAdminLoading());
    try {
      final orders = await orderRepository.getAllOrders();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(OrderAdminLoaded(
        orders: orders,
        filteredOrders: orders,
      ));
    } catch (e) {
      emit(OrderAdminError('Failed to load orders: ${e.toString()}'));
    }
  }

  void _onFilterOrders(
    FilterOrders event,
    Emitter<OrderAdminState> emit,
  ) {
    if (state is OrderAdminLoaded) {
      final currentState = state as OrderAdminLoaded;
      final orders = currentState.orders;

      List<Order> filtered = List.from(orders);

      if (event.startDate != null) {
        filtered = filtered.where((order) {
          return order.createdAt.isAfter(
                event.startDate!.subtract(const Duration(days: 1)),
              ) ||
              order.createdAt.isAtSameMomentAs(event.startDate!);
        }).toList();
      }

      if (event.endDate != null) {
        final endOfDay = DateTime(
          event.endDate!.year,
          event.endDate!.month,
          event.endDate!.day,
          23,
          59,
          59,
        );
        filtered = filtered.where((order) {
          return order.createdAt.isBefore(endOfDay) ||
              order.createdAt.isAtSameMomentAs(endOfDay);
        }).toList();
      }

      emit(currentState.copyWith(
        filteredOrders: filtered,
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    }
  }
}
