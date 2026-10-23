import 'api_client.dart';

/// Abstract Base Remote Data Source.
abstract class BaseRemoteDataSource {
  final ApiClient apiClient;

  const BaseRemoteDataSource(this.apiClient);
}
