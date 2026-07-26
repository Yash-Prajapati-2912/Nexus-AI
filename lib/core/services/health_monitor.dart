import 'dart:async';
import 'app_logger.dart';

class HealthStatus {
  final double averageLatencyMs;
  final int activeNetworkRequests;
  final int totalSyncErrors;
  final DateTime timestamp;

  const HealthStatus({
    required this.averageLatencyMs,
    required this.activeNetworkRequests,
    required this.totalSyncErrors,
    required this.timestamp,
  });
}

class HealthMonitor {
  int _activeRequests = 0;
  int _syncErrors = 0;
  final List<int> _latencies = [];

  final StreamController<HealthStatus> _controller = StreamController<HealthStatus>.broadcast();
  Stream<HealthStatus> get statusStream => _controller.stream;

  void trackRequestStarted() {
    _activeRequests++;
    _notify();
  }

  void trackRequestEnded(int latencyMs, {bool isSuccess = true}) {
    if (_activeRequests > 0) _activeRequests--;
    _latencies.add(latencyMs);
    if (_latencies.length > 50) _latencies.removeAt(0);

    if (!isSuccess) _syncErrors++;
    _notify();
  }

  void _notify() {
    final avgLatency = _latencies.isEmpty ? 0.0 : _latencies.reduce((a, b) => a + b) / _latencies.length;
    _controller.add(
      HealthStatus(
        averageLatencyMs: avgLatency,
        activeNetworkRequests: _activeRequests,
        totalSyncErrors: _syncErrors,
        timestamp: DateTime.now(),
      ),
    );
  }

  void dispose() {
    _controller.close();
  }
}
