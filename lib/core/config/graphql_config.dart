import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLConfig {
  // Change these URLs based on your setup:
  // - iOS Simulator: localhost
  // - Android Emulator: 10.0.2.2
  // - Physical Device: Your computer's IP (e.g., 192.168.1.100)
  static const String _httpUrl = 'http://localhost:4000/graphql';
  static const String _wsUrl = 'ws://localhost:4000/graphql';
  
  // Set to false to disable WebSocket if backend not ready
  static const bool enableWebSocket = true;

  static HttpLink httpLink = HttpLink(_httpUrl);
  
  static WebSocketLink? _wsLink;
  
  static WebSocketLink getWebSocketLink() {
    if (_wsLink == null) {
      if (kDebugMode) {
        print('🔌 Initializing WebSocket connection to: $_wsUrl');
      }
      
      _wsLink = WebSocketLink(
        _wsUrl,
        config: const SocketClientConfig(
          autoReconnect: true,
          inactivityTimeout: Duration(seconds: 30),
          initialPayload: {},
          // connectivityCheck: null,
        ),
        subProtocol: GraphQLProtocol.graphqlTransportWs,
      );
      
      if (kDebugMode) {
        print('✅ WebSocket link created with graphql-transport-ws protocol');
      }
    }
    return _wsLink!;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<AuthLink> getAuthLink() async {
    final token = await getToken();
    return AuthLink(
      getToken: () async => token != null ? 'Bearer $token' : null,
    );
  }

  static Future<GraphQLClient> getClient() async {
    final authLink = await getAuthLink();
    final link = authLink.concat(httpLink);

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }
  
  static Future<GraphQLClient> getClientWithSubscription() async {
    final authLink = await getAuthLink();
    
    // If WebSocket disabled, fallback to HTTP only
    if (!enableWebSocket) {
      if (kDebugMode) {
        print('ℹ️  WebSocket disabled. Using HTTP only.');
      }
      return getClient();
    }
    
    try {
      final wsLink = getWebSocketLink();
      
      final link = Link.split(
        (request) => request.isSubscription,
        wsLink,
        authLink.concat(httpLink),
      );

      return GraphQLClient(
        link: link,
        cache: GraphQLCache(store: InMemoryStore()),
      );
    } catch (e) {
      if (kDebugMode) {
        print('⚠️  WebSocket initialization failed: $e');
        print('📡 Falling back to HTTP only mode');
      }
      // Fallback to HTTP only if WebSocket fails
      return getClient();
    }
  }

  static Future<ValueNotifier<GraphQLClient>> initializeClient() async {
    final client = await getClientWithSubscription();
    return ValueNotifier(client);
  }
  
  static void disposeWebSocket() {
    _wsLink?.dispose();
    _wsLink = null;
  }
}
