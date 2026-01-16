import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/repositories/order_repository.dart';
import 'package:ticketing_flutter/data/repositories/email_subscription_service.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;
  final EmailSubscriptionService emailSubscriptionService;
  StreamSubscription? _emailSubscription;

  OrderBloc({
    required this.orderRepository,
    required this.emailSubscriptionService,
  }) : super(OrderInitial()) {
    on<CreateOrder>(_onCreateOrder);
    on<CreateOrderSuccess>(_onCreateOrderSuccess);
    on<SubscribeToEmailStatus>(_onSubscribeToEmailStatus);
    on<EmailStatusReceived>(_onEmailStatusReceived);
    on<UnsubscribeEmailStatus>(_onUnsubscribeEmailStatus);
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    try {
      final order = await orderRepository.createOrder(event.items);
      emit(OrderSuccess(order));
      
      // Automatically subscribe to email status after order created
      add(SubscribeToEmailStatus(order.id));
    } catch (e) {
      emit(OrderError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void _onCreateOrderSuccess(
    CreateOrderSuccess event,
    Emitter<OrderState> emit,
  ) {
    emit(OrderSuccess(event.order));
  }

  Future<void> _onSubscribeToEmailStatus(
    SubscribeToEmailStatus event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await emailSubscriptionService.initialize();
      emailSubscriptionService.subscribeToEmailStatus(event.orderId);

      _emailSubscription = emailSubscriptionService.emailStatusUpdates.listen(
        (update) {
          add(EmailStatusReceived(update));
        },
      );
    } catch (e) {
      print('⚠️ Failed to subscribe to email status: $e');
    }
  }

  void _onEmailStatusReceived(
    EmailStatusReceived event,
    Emitter<OrderState> emit,
  ) {
    final currentState = state;
    if (currentState is OrderSuccess) {
      emit(currentState.copyWith(emailStatus: event.update));
    }
  }

  void _onUnsubscribeEmailStatus(
    UnsubscribeEmailStatus event,
    Emitter<OrderState> emit,
  ) {
    _emailSubscription?.cancel();
    emailSubscriptionService.unsubscribe();
  }

  @override
  Future<void> close() {
    _emailSubscription?.cancel();
    emailSubscriptionService.dispose();
    return super.close();
  }
}
