import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/models/order_model.dart';
import 'package:ticketing_flutter/data/repositories/email_subscription_service.dart';
import 'package:ticketing_flutter/data/repositories/order_repository.dart';
import 'package:ticketing_flutter/modules/home/bloc/order/order_bloc.dart';
import 'package:ticketing_flutter/modules/home/bloc/order/order_event.dart';
import 'package:ticketing_flutter/modules/home/bloc/order/order_state.dart';
import 'package:ticketing_flutter/modules/home/widgets/email_status_notification.dart';

class OrderSuccessScreen extends StatefulWidget {
  final Order order;
  
  const OrderSuccessScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  late OrderBloc _orderBloc;

  @override
  void initState() {
    super.initState();
    _orderBloc = OrderBloc(
      orderRepository: OrderRepository(),
      emailSubscriptionService: EmailSubscriptionService(),
    );
    
    // Set initial state dengan order yang sudah dibuat
    _orderBloc.add(CreateOrderSuccess(widget.order));
    // Subscribe to email status
    _orderBloc.add(SubscribeToEmailStatus(widget.order.id));
  }

  @override
  void dispose() {
    _orderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _orderBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Berhasil'),
        ),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderSuccess) {
              return Column(
              children: [
                // Email status notification banner
                const EmailStatusNotification(),
                  
                  // Order details
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 48,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Order Berhasil!',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Order ID: #${state.order.id}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  
                                  // Order items
                                  if (state.order.details != null) ...[
                                    const Text(
                                      'Detail Order:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ...state.order.details!.map((detail) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    detail.ticket?.event?.title ?? 'Unknown Event',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${detail.ticket?.name ?? 'Unknown Ticket'} x ${detail.qty}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              'Rp ${((detail.ticket?.price ?? 0) * detail.qty).toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    const Divider(height: 24),
                                  ],
                                  
                                  // Total
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Rp ${state.order.totalPrice.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Info box
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Detail order dan tiket Anda akan dikirim via email',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            
            return const Center(
              child: Text('Tidak ada data order'),
            );
          },
        ),
      ),
    );
  }
}
