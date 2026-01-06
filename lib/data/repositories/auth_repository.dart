import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ticketing_flutter/core/config/graphql_config.dart';
import 'package:ticketing_flutter/data/models/user_model.dart';

class AuthRepository {
  Future<UserModel> login(String email, String password) async {
    final client = await GraphQLConfig.getClient();

    const String loginMutation = r'''
      mutation Login($data: LoginInput!) {
        login(data: $data) {
          accessToken
          user {
            id
            name
            email
            role {
              id
              name
            }
          }
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(loginMutation),
      variables: {
        'data': {
          'email': email,
          'password': password,
        },
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(
        result.exception?.graphqlErrors.isNotEmpty == true
            ? result.exception!.graphqlErrors.first.message
            : 'Login failed. Please try again.',
      );
    }

    if (result.data == null || result.data!['login'] == null) {
      throw Exception('Invalid response from server');
    }

    final loginData = result.data!['login'];
    final accessToken = loginData['accessToken'];
    final userData = loginData['user'];

    if (accessToken == null) {
      throw Exception('No access token received');
    }

    if (userData == null) {
      throw Exception('No user data received');
    }

    await GraphQLConfig.saveToken(accessToken);

    return UserModel.fromJson({
      ...userData,
      'token': accessToken,
    });
  }

  Future<void> logout() async {
    await GraphQLConfig.removeToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await GraphQLConfig.getToken();
    return token != null;
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final client = await GraphQLConfig.getClient();

      const String getMeQuery = r'''
        query GetMe {
          Me
        }
      ''';

      final QueryOptions options = QueryOptions(
        document: gql(getMeQuery),
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        return null;
      }

      if (result.data == null || result.data!['Me'] == null) {
        return null;
      }

      final userId = result.data!['Me'] as String;
      final token = await GraphQLConfig.getToken();
      
      return UserModel(
        id: userId,
        email: '',
        name: '',
        token: token,
      );
    } catch (e) {
      return null;
    }
  }
}
