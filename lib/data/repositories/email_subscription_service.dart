import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ticketing_flutter/core/config/graphql_config.dart';
import 'package:ticketing_flutter/data/models/email_status_model.dart';

class EmailSubscriptionService {
  GraphQLClient? _client;
  StreamSubscription? _subscription;
  final StreamController<EmailStatusUpdate> _controller =
      StreamController<EmailStatusUpdate>.broadcast();
  bool _isInitialized = false;
  bool _isConnected = false;

  Stream<EmailStatusUpdate> get emailStatusUpdates => _controller.stream;
  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _client = await GraphQLConfig.getClientWithSubscription();
      _isInitialized = true;
      if (kDebugMode) {
        print('✅ Email subscription service initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Email subscription service initialization failed: $e');
        print('📱 Continuing without email real-time updates');
      }
      _isInitialized = false;
    }
  }

  void subscribeToEmailStatus(int orderId) {
    if (_client == null) {
      if (kDebugMode) {
        print('⚠️ WebSocket client not initialized. Skipping email subscription.');
      }
      return;
    }

    const String subscription = r'''
      subscription EmailStatusUpdated($orderId: Float!) {
        emailStatusUpdated(orderId: $orderId) {
          emailLogId
          orderId
          status
          error
          updatedAt
        }
      }
    ''';

    final options = SubscriptionOptions(
      document: gql(subscription),
      variables: {'orderId': orderId},
    );

    if (kDebugMode) {
      print('🔔 Subscribing to email status updates for order $orderId');
    }

    _subscription = _client!.subscribe(options).listen(
      (result) {
        _isConnected = true;

        if (result.hasException) {
          if (kDebugMode) {
            print('⚠️ Email subscription exception: ${result.exception}');
          }
          return;
        }

        if (result.data != null &&
            result.data!['emailStatusUpdated'] != null) {
          try {
            final update = EmailStatusUpdate.fromJson(
              result.data!['emailStatusUpdated'],
            );

            if (kDebugMode) {
              print('📧 Email status update received:');
              print('   Order ID: ${update.orderId}');
              print('   Status: ${update.status}');
              print('   Message: ${update.statusMessage}');
            }

            _controller.add(update);
          } catch (e) {
            if (kDebugMode) {
              print('⚠️ Failed to parse email status update: $e');
            }
          }
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('❌ Email subscription stream error: $error');
        }
        _isConnected = false;
      },
      onDone: () {
        if (kDebugMode) {
          print('✅ Email subscription stream closed');
        }
        _isConnected = false;
      },
    );
  }

  void unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
    _isConnected = false;

    if (kDebugMode) {
      print('🔕 Email subscription cancelled');
    }
  }

  void dispose() {
    unsubscribe();
    _controller.close();
    _isInitialized = false;

    if (kDebugMode) {
      print('♻️ Email subscription service disposed');
    }
  }
}
