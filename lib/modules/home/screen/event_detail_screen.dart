import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ticketing_flutter/core/constants/app_color.dart';
import 'package:ticketing_flutter/data/models/event_model.dart';
import 'package:ticketing_flutter/data/models/order_input_model.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';
import 'package:ticketing_flutter/data/repositories/order_repository.dart';
import 'package:ticketing_flutter/data/repositories/email_subscription_service.dart';
import 'package:ticketing_flutter/modules/home/bloc/order/order_bloc.dart';
import 'package:ticketing_flutter/modules/home/bloc/order/order_event.dart';
import 'package:ticketing_flutter/modules/home/bloc/order/order_state.dart';
import 'package:ticketing_flutter/modules/home/screen/order_success_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final int eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  Event? event;
  bool isLoading = true;
  String? errorMessage;
  Map<int, int> selectedQuantities = {};

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    try {
      final eventRepository = EventRepository();
      final loadedEvent = await eventRepository.getEvent(widget.eventId);
      setState(() {
        event = loadedEvent;
        isLoading = false;
        // Initialize quantities
        if (event?.tickets != null) {
          for (var ticket in event!.tickets!) {
            selectedQuantities[ticket.id] = 0;
          }
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _incrementQuantity(int ticketId) {
    setState(() {
      selectedQuantities[ticketId] = (selectedQuantities[ticketId] ?? 0) + 1;
    });
  }

  void _decrementQuantity(int ticketId) {
    setState(() {
      final current = selectedQuantities[ticketId] ?? 0;
      if (current > 0) {
        selectedQuantities[ticketId] = current - 1;
      }
    });
  }

  int _getTotalQuantity() {
    return selectedQuantities.values.fold(0, (sum, qty) => sum + qty);
  }

  double _getTotalPrice() {
    double total = 0;
    if (event?.tickets != null) {
      for (var ticket in event!.tickets!) {
        final qty = selectedQuantities[ticket.id] ?? 0;
        total += ticket.price * qty;
      }
    }
    return total;
  }

  List<OrderInput> _getOrderItems() {
    List<OrderInput> items = [];
    selectedQuantities.forEach((ticketId, qty) {
      if (qty > 0) {
        items.add(OrderInput(ticketId: ticketId, qty: qty));
      }
    });
    return items;
  }

  Widget _buildEventDetail() {
    if (event == null) return const SizedBox();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/konser.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 100),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title
                Text(
                  event!.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // Category
                if (event!.category != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event!.category!.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Date & Time
                _buildInfoRow(
                  Icons.calendar_today,
                  DateFormat('EEEE, MMM dd, yyyy • HH:mm').format(event!.date),
                ),
                const SizedBox(height: 12),

                // Location
                _buildInfoRow(Icons.location_on, event!.location),
                const SizedBox(height: 20),

                // Description
                const Text(
                  'About Event',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event!.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Tickets Section
                const Text(
                  'Select Tickets',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                if (event!.tickets == null || event!.tickets!.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No tickets available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...event!.tickets!.map((ticket) => _buildTicketCard(ticket)),

                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard(ticket) {
    final quantity = selectedQuantities[ticket.id] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: quantity > 0 ? AppColors.primary : Colors.grey[300]!,
          width: quantity > 0 ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${ticket.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => _decrementQuantity(ticket.id),
                      icon: const Icon(Icons.remove),
                      color: Colors.black87,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _incrementQuantity(ticket.id),
                      icon: const Icon(Icons.add),
                      color: AppColors.primary,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Available: ${ticket.quota}',
            style: TextStyle(
              fontSize: 12,
              color: ticket.quota > 0 ? Colors.grey : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final totalQty = _getTotalQuantity();
    final totalPrice = _getTotalPrice();

    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate ke OrderSuccessScreen dengan order data
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrderSuccessScreen(order: state.order),
            ),
          );
        } else if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is OrderLoading;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '$totalQty ticket${totalQty != 1 ? 's' : ''}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: totalQty > 0 && !isLoading
                        ? () {
                            final items = _getOrderItems();
                            context.read<OrderBloc>().add(CreateOrder(items));
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Order Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderBloc(
        orderRepository: OrderRepository(),
        emailSubscriptionService: EmailSubscriptionService(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadEvent,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      _buildEventDetail(),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: _buildBottomBar(),
                      ),
                    ],
                  ),
      ),
    );
  }
}
