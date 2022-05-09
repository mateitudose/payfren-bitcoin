import 'package:appwrite/appwrite.dart';
import 'package:payfren/config.dart';

class ApiClient {
  Client get _client {
    Client client = Client();

    client
        .setEndpoint(Config.endPoint)
        .setProject(Config.project);

    return client;
  }

  static Account get account => Account(_instance._client);
  static Database get database => Database(_instance._client);
  static Storage get storage => Storage(_instance._client);

  static final ApiClient _instance = ApiClient._internal();
  ApiClient._internal();
  factory ApiClient() => _instance;
}