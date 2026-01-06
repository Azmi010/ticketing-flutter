import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ticketing_flutter/core/config/graphql_config.dart';
import '../models/ticket_type_model.dart';

class TicketTypeRepository {
  // Get all tickets
  Future<List<TicketType>> getTickets() async {
    final client = await GraphQLConfig.getClient();

    const String ticketsQuery = r'''
      query GetTickets {
        tickets {
          id
          name
          price
          quota
          event {
            id
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(ticketsQuery),
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Failed to load tickets',
      );
    }

    if (result.data == null || result.data!['tickets'] == null) {
      return [];
    }

    final List ticketsList = result.data!['tickets'];
    return ticketsList.map((json) => TicketType.fromJson(json)).toList();
  }

  // Create ticket
  Future<TicketType> createTicket({
    required int eventId,
    required String name,
    required double price,
    required int quota,
  }) async {
    final client = await GraphQLConfig.getClient();

    const String createTicketMutation = r'''
      mutation CreateTicket($eventId: Float!, $data: TicketInput!) {
        createTicket(eventId: $eventId, data: $data) {
          id
          name
          price
          quota
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(createTicketMutation),
      variables: {
        'eventId': eventId,
        'data': {
          'name': name,
          'price': price,
          'quota': quota,
        },
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Failed to create ticket',
      );
    }

    if (result.data == null || result.data!['createTicket'] == null) {
      throw Exception('Failed to create ticket');
    }

    return TicketType.fromJson(result.data!['createTicket']);
  }

  // Update ticket
  Future<TicketType> updateTicket({
    required int id,
    required String name,
    required double price,
    required int quota,
  }) async {
    final client = await GraphQLConfig.getClient();

    const String updateTicketMutation = r'''
      mutation UpdateTicket($id: Float!, $data: TicketInput!) {
        updateTicket(id: $id, data: $data) {
          id
          name
          price
          quota
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(updateTicketMutation),
      variables: {
        'id': id,
        'data': {
          'name': name,
          'price': price,
          'quota': quota,
        },
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Failed to update ticket',
      );
    }

    if (result.data == null || result.data!['updateTicket'] == null) {
      throw Exception('Failed to update ticket');
    }

    return TicketType.fromJson(result.data!['updateTicket']);
  }

  // Delete ticket
  Future<bool> deleteTicket(int id) async {
    final client = await GraphQLConfig.getClient();

    const String deleteTicketMutation = r'''
      mutation DeleteTicket($id: Float!) {
        deleteTicket(id: $id)
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(deleteTicketMutation),
      variables: {'id': id},
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Failed to delete ticket',
      );
    }

    return result.data?['deleteTicket'] ?? false;
  }
}
