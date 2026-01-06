import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ticketing_flutter/core/config/graphql_config.dart';
import '../models/order_model.dart';
import '../models/order_input_model.dart';

class OrderRepository {
  // Create order
  Future<Order> createOrder(List<OrderInput> items) async {
    final client = await GraphQLConfig.getClient();

    const String createOrderMutation = r'''
      mutation CreateOrder($items: [OrderInput!]!) {
        createOrder(items: $items) {
          id
          total_price
          createdAt
          details {
            id
            qty
            ticket {
              id
              name
              price
            }
          }
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(createOrderMutation),
      variables: {
        'items': items.map((item) => item.toJson()).toList(),
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Failed to create order',
      );
    }

    if (result.data == null || result.data!['createOrder'] == null) {
      throw Exception('Failed to create order');
    }

    return Order.fromJson(result.data!['createOrder']);
  }

  // Get user orders
  Future<List<Order>> getMyOrders() async {
    final client = await GraphQLConfig.getClient();

    const String myOrdersQuery = r'''
      query MyOrders {
        myOrders {
          id
          total_price
          createdAt
          details {
            id
            qty
            ticket {
              id
              name
              price
              event {
                id
                title
                date
                location
              }
            }
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(myOrdersQuery),
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Failed to load orders',
      );
    }

    if (result.data == null || result.data!['myOrders'] == null) {
      return [];
    }

    final List ordersList = result.data!['myOrders'];
    return ordersList.map((json) => Order.fromJson(json)).toList();
  }
}
