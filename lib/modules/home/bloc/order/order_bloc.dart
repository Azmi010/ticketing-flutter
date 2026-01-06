import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(OrderInitial()) {
    on<CreateOrder>(_onCreateOrder);
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    try {
      final order = await orderRepository.createOrder(event.items);
      emit(OrderSuccess(order));
    } catch (e) {
      emit(OrderError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
