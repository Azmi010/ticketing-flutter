import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLConfig {
  static const String _apiUrl = 'http://localhost:4000/graphql';

  static HttpLink httpLink = HttpLink(_apiUrl);

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

  static Future<ValueNotifier<GraphQLClient>> initializeClient() async {
    final client = await getClient();
    return ValueNotifier(client);
  }
}
