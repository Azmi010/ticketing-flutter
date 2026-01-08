import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ticketing_flutter/core/config/graphql_config.dart';
import '../models/category_model.dart';
import '../models/event_model.dart';
import '../models/search_event_input_model.dart';
import '../models/search_event_response_model.dart';

class EventRepository {
  // Get all events
  Future<List<Event>> getEvents() async {
    final client = await GraphQLConfig.getClient();

    const String eventsQuery = r'''
      query GetEvents {
        events {
          id
          title
          description
          location
          date
          category {
            id
            name
          }
          tickets {
            id
            name
            price
            quota
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(eventsQuery),
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Failed to load events',
      );
    }

    if (result.data == null || result.data!['events'] == null) {
      return [];
    }

    final List eventsList = result.data!['events'];
    return eventsList.map((json) => Event.fromJson(json)).toList();
  }

  // Get single event by ID
  Future<Event> getEvent(int id) async {
    final client = await GraphQLConfig.getClient();

    const String eventQuery = r'''
      query GetEvent($id: Float!) {
        event(id: $id) {
          id
          title
          description
          location
          date
          category {
            id
            name
          }
          organizer {
            id
            name
            email
          }
          tickets {
            id
            name
            price
            quota
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(eventQuery),
      variables: {'id': id},
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Failed to load event',
      );
    }

    if (result.data == null || result.data!['event'] == null) {
      throw Exception('Event not found');
    }

    return Event.fromJson(result.data!['event']);
  }

  // Create event
  Future<Event> createEvent({
    required String title,
    required String description,
    required String location,
    required DateTime date,
    required int categoryId,
    required int organizerId,
  }) async {
    final client = await GraphQLConfig.getClient();

    const String createEventMutation = r'''
      mutation CreateEvent($data: EventInput!) {
        createEvent(data: $data) {
          id
          title
          description
          location
          date
          category {
            id
            name
          }
          organizer {
            id
            name
            email
          }
        }
      }
    ''';

    final formattedDate = '${date.toUtc().toIso8601String().split('.').first}Z';
    
    final MutationOptions options = MutationOptions(
      document: gql(createEventMutation),
      variables: {
        'data': {
          'title': title,
          'description': description,
          'location': location,
          'date': formattedDate,
          'categoryId': categoryId,
          'organizerId': organizerId,
        },
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Failed to create event',
      );
    }

    if (result.data == null || result.data!['createEvent'] == null) {
      throw Exception('Failed to create event');
    }

    return Event.fromJson(result.data!['createEvent']);
  }

  // Update event
  Future<Event> updateEvent({
    required int id,
    required String title,
    required String description,
    required String location,
    required DateTime date,
    required int categoryId,
    required int organizerId,
  }) async {
    final client = await GraphQLConfig.getClient();

    const String updateEventMutation = r'''
      mutation UpdateEvent($id: Float!, $data: EventInput!) {
        updateEvent(id: $id, data: $data) {
          id
          title
          description
          location
          date
          category {
            id
            name
          }
          organizer {
            id
            name
            email
          }
        }
      }
    ''';

    final formattedDate = '${date.toUtc().toIso8601String().split('.').first}Z';

    final MutationOptions options = MutationOptions(
      document: gql(updateEventMutation),
      variables: {
        'id': id,
        'data': {
          'title': title,
          'description': description,
          'location': location,
          'date': formattedDate,
          'categoryId': categoryId,
          'organizerId': organizerId,
        },
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Failed to update event',
      );
    }

    if (result.data == null || result.data!['updateEvent'] == null) {
      throw Exception('Failed to update event');
    }

    return Event.fromJson(result.data!['updateEvent']);
  }

  // Delete event
  Future<bool> deleteEvent(int id) async {
    final client = await GraphQLConfig.getClient();

    const String deleteEventMutation = r'''
      mutation DeleteEvent($id: Float!) {
        deleteEvent(id: $id)
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(deleteEventMutation),
      variables: {'id': id},
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Failed to delete event',
      );
    }

    return result.data?['deleteEvent'] ?? false;
  }

  // Get event categories
  Future<List<Category>> getCategories() async {
    final client = await GraphQLConfig.getClient();

    const String categoriesQuery = r'''
      query GetCategories {
        eventCategories {
          id
          name
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(categoriesQuery),
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Failed to load categories',
      );
    }

    if (result.data == null || result.data!['eventCategories'] == null) {
      return [];
    }

    final List categoriesList = result.data!['eventCategories'];
    return categoriesList.map((json) => Category.fromJson(json)).toList();
  }

  Future<List<Category>> getBrowseCategories() async {
    return getCategories();
  }

  Future<List<Event>> getWeekendEvents() async {
    final allEvents = await getEvents();
    return allEvents;
  }

  Future<List<Event>> getFreeEvents() async {
    final allEvents = await getEvents();
    return allEvents;
  }

  // Search events with filters
  Future<List<SearchEventResponse>> searchEvents(SearchEventInput input) async {
    final client = await GraphQLConfig.getClient();

    const String searchEventsQuery = r'''
      query SearchEvents($input: SearchEventInput!) {
        searchEvents(input: $input) {
          id
          title
          description
          location
          date
          categoryName
          organizerName
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(searchEventsQuery),
      variables: {'input': input.toJson()},
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Failed to search events',
      );
    }

    if (result.data == null || result.data!['searchEvents'] == null) {
      return [];
    }

    final List searchResultsList = result.data!['searchEvents'];
    return searchResultsList.map((json) => SearchEventResponse.fromJson(json)).toList();
  }
}