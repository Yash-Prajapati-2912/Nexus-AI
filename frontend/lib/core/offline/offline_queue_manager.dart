import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/app_logger.dart';
import 'conflict_resolver.dart';

class QueueItem {
  final String id;
  final String endpoint;
  final String method;
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  final int retryCount;

  QueueItem({
    required this.id,
    required this.endpoint,
    required this.method,
    required this.payload,
    required this.timestamp,
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'endpoint': endpoint,
        'method': method,
        'payload': payload,
        'timestamp': timestamp.toIso8601String(),
        'retryCount': retryCount,
      };

  factory QueueItem.fromJson(Map<String, dynamic> json) => QueueItem(
        id: json['id'] as String,
        endpoint: json['endpoint'] as String,
        method: json['method'] as String,
        payload: Map<String, dynamic>.from(json['payload'] as Map),
        timestamp: DateTime.parse(json['timestamp'] as String),
        retryCount: json['retryCount'] as int? ?? 0,
      );

  QueueItem incrementRetry() => QueueItem(
        id: id,
        endpoint: endpoint,
        method: method,
        payload: payload,
        timestamp: timestamp,
        retryCount: retryCount + 1,
      );
}

class OfflineQueueManager {
  final SharedPreferences preferences;
  static const String _queueStorageKey = 'offline_mutation_queue_v1';

  OfflineQueueManager(this.preferences);

  Future<void> enqueue(String endpoint, String method, Map<String, dynamic> payload) async {
    final queue = await getPendingQueue();
    final newItem = QueueItem(
      id: 'queue_${DateTime.now().millisecondsSinceEpoch}',
      endpoint: endpoint,
      method: method,
      payload: payload,
      timestamp: DateTime.now(),
    );
    queue.add(newItem);
    await _saveQueue(queue);
    AppLogger.info('OfflineQueueManager: Enqueued offline mutation [${newItem.method} ${newItem.endpoint}]');
  }

  Future<List<QueueItem>> getPendingQueue() async {
    final raw = preferences.getString(_queueStorageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((item) => QueueItem.fromJson(Map<String, dynamic>.from(item as Map))).toList();
    } catch (e) {
      AppLogger.error('OfflineQueueManager: Failed to parse stored queue', e);
      return [];
    }
  }

  Future<int> getPendingCount() async {
    final queue = await getPendingQueue();
    return queue.length;
  }

  Future<bool> processQueueItem(QueueItem item, ConflictResolver resolver) async {
    if (item.retryCount >= 5) {
      AppLogger.warning('OfflineQueueManager: Max retries exceeded for ${item.id}. Evicting item.');
      await dequeue(item.id);
      return false;
    }

    try {
      // Execute network mutation
      AppLogger.info('OfflineQueueManager: Processing queue item ${item.id}');
      await dequeue(item.id);
      return true;
    } catch (e) {
      AppLogger.error('OfflineQueueManager: Failed processing item ${item.id}', e);
      final queue = await getPendingQueue();
      final index = queue.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        queue[index] = item.incrementRetry();
        await _saveQueue(queue);
      }
      return false;
    }
  }

  Future<void> dequeue(String id) async {
    final queue = await getPendingQueue();
    queue.removeWhere((item) => item.id == id);
    await _saveQueue(queue);
  }

  Future<void> clearQueue() async {
    await preferences.remove(_queueStorageKey);
  }

  Future<void> _saveQueue(List<QueueItem> queue) async {
    final raw = jsonEncode(queue.map((item) => item.toJson()).toList());
    await preferences.setString(_queueStorageKey, raw);
  }
}
