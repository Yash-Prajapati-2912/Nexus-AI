import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Network Connectivity Status Inspector & Stream Provider.
class ConnectivityService {
  final Connectivity _connectivity;
  final StreamController<bool> _connectivityStreamController =
      StreamController<bool>.broadcast();

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity() {
    _connectivity.onConnectivityChanged.listen((results) {
      final isConnected = _hasInternetAccess(results);
      _connectivityStreamController.add(isConnected);
    });
  }

  Stream<bool> get onConnectivityChanged =>
      _connectivityStreamController.stream;

  Stream<bool> get connectivityStream =>
      _connectivityStreamController.stream;

  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _hasInternetAccess(results);
  }

  bool _hasInternetAccess(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);
  }

  void dispose() {
    _connectivityStreamController.close();
  }
}
