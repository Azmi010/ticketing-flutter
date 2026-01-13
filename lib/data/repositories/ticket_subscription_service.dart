import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ticketing_flutter/core/config/graphql_config.dart';

class TicketStockUpdate {
  final int ticketId;
  final String ticketName;
  final int eventId;
  final String eventTitle;
  final int remainingStock;
  final int previousStock;
  final DateTime updatedAt;

  TicketStockUpdate({
    required this.ticketId,
    required this.ticketName,
    required this.eventId,
    required this.eventTitle,
    required this.remainingStock,
    required this.previousStock,
    required this.updatedAt,
  });

  factory TicketStockUpdate.fromJson(Map<String, dynamic> json) {
    return TicketStockUpdate(
      ticketId: json['ticketId'] is int 
          ? json['ticketId'] 
          : int.parse(json['ticketId'].toString()),
      ticketName: json['ticketName'] ?? '',
      eventId: json['eventId'] is int 
          ? json['eventId'] 
          : int.parse(json['eventId'].toString()),
      eventTitle: json['eventTitle'] ?? '',
      remainingStock: json['remainingStock'] is int 
          ? json['remainingStock'] 
          : int.parse(json['remainingStock'].toString()),
      previousStock: json['previousStock'] is int 
          ? json['previousStock'] 
          : int.parse(json['previousStock'].toString()),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }
}

class TicketSubscriptionService {
  GraphQLClient? _client;
  StreamSubscription? _subscription;
  final StreamController<TicketStockUpdate> _controller = 
      StreamController<TicketStockUpdate>.broadcast();
  bool _isInitialized = false;
  bool _isConnected = false;

  Stream<TicketStockUpdate> get stockUpdates => _controller.stream;
  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _client = await GraphQLConfig.getClientWithSubscription();
      _isInitialized = true;
      if (kDebugMode) {
        print('✅ Subscription service initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Subscription service initialization failed: $e');
        print('📱 Continuing without real-time updates');
      }
      _isInitialized = false;
    }
  }

  void subscribeToEventTickets(int eventId) {
    if (_client == null) {
      if (kDebugMode) {
        print('⚠️ WebSocket client not initialized. Skipping subscription.');
      }
      return;
    }

    const String subscription = r'''
      subscription TicketStockUpdatedByEvent($eventId: Float!) {
        ticketStockUpdatedByEvent(eventId: $eventId) {
          ticketId
          ticketName
          eventId
          eventTitle
          remainingStock
          previousStock
          updatedAt
        }
      }
    ''';

    final options = SubscriptionOptions(
      document: gql(subscription),
      variables: {'eventId': eventId},
    );

    _subscription = _client!.subscribe(options).listen(
      (result) {
        if (result.hasException) {
          if (kDebugMode) {
            print('❌ Subscription error: ${result.exception.toString()}');
          }
          _isConnected = false;
          return;
        }

        _isConnected = true;
        if (result.data != null && 
            result.data!['ticketStockUpdatedByEvent'] != null) {
          final update = TicketStockUpdate.fromJson(
            result.data!['ticketStockUpdatedByEvent']
          );
          _controller.add(update);
        }
      },
      onError: (error) {
        _isConnected = false;
        if (kDebugMode) {
          print('❌ Subscription stream error: $error');
        }
      },
    );
  }

  void subscribeToAllTickets() {
    if (_client == null) {
      if (kDebugMode) {
        print('⚠️ WebSocket client not initialized. Skipping subscription.');
      }
      return;
    }

    const String subscription = r'''
      subscription TicketStockUpdated {
        ticketStockUpdated {
          ticketId
          ticketName
          eventId
          eventTitle
          remainingStock
          previousStock
          updatedAt
        }
      }
    ''';

    final options = SubscriptionOptions(
      document: gql(subscription),
    );

    try {
      _subscription = _client!.subscribe(options).listen(
        (result) {
          if (result.hasException) {
            if (kDebugMode) {
              print('❌ Subscription error: ${result.exception.toString()}');
            }
            _isConnected = false;
            return;
          }

          _isConnected = true;
          if (result.data != null && 
              result.data!['ticketStockUpdated'] != null) {
            final update = TicketStockUpdate.fromJson(
              result.data!['ticketStockUpdated']
            );
            _controller.add(update);
            if (kDebugMode) {
              print('✅ Received ticket update: Event ${update.eventId}, Ticket ${update.ticketId}, Stock: ${update.remainingStock}');
            }
          }
        },
        onError: (error) {
          _isConnected = false;
          if (kDebugMode) {
            print('❌ Subscription stream error: $error');
          }
        },
        onDone: () {
          _isConnected = false;
          if (kDebugMode) {
            print('🔌 Subscription stream closed');
          }
        },
      );
    } catch (e) {
      _isConnected = false;
      if (kDebugMode) {
        print('❌ Failed to subscribe: $e');
      }
    }
  }

  void unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
    _client = null;
  }
}
