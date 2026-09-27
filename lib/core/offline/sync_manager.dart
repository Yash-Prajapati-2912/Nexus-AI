import 'dart:async';
import '../services/connectivity_service.dart';
import '../services/app_logger.dart';
import 'offline_queue_manager.dart';
import 'conflict_resolver.dart';

enum SyncState { idle, syncing, success, error }

class SyncStatus {
  final SyncState state;
  final int pendingItemsCount;
  final String? lastError;
  final DateTime? lastSyncTime;

  const SyncStatus({
    required this.state,
    required this.pendingItemsCount,
    this.lastError,
    this.lastSyncTime,
  });
}

class SyncManager {
  final ConnectivityService connectivityService;
  final OfflineQueueManager queueManager;
  final ConflictResolver conflictResolver;

  final StreamController<SyncStatus> _statusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get statusStream => _statusController.stream;

  Timer? _periodicTimer;
  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  SyncManager({
    required this.connectivityService,
    required this.queueManager,
    required this.conflictResolver,
  });

  void initialize() {
    connectivityService.connectivityStream.listen((isConnected) {
      if (isConnected) {
        AppLogger.info('Network restored. Triggering automatic background synchronization.');
        unawaited(triggerSync());
      }
    });

    _periodicTimer = Timer.periodic(const Duration(minutes: 15), (_) async {
      if (await connectivityService.isConnected) {
        unawaited(triggerSync());
      }
    });

    _notifyStatus(SyncState.idle);
  }

  Future<void> triggerSync() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _notifyStatus(SyncState.syncing);

    try {
      final queue = await queueManager.getPendingQueue();
      AppLogger.info('SyncManager: Processing ${queue.length} queued offline mutations.');

      for (final item in queue) {
        final success = await queueManager.processQueueItem(item, conflictResolver);
        if (!success) {
          AppLogger.warning('SyncManager: Queue item ${item.id} retry deferred.');
        }
      }

      _lastSyncTime = DateTime.now();
      _isSyncing = false;
      _notifyStatus(SyncState.success);
    } catch (e, stack) {
      AppLogger.error('SyncManager: Error during sync execution', e, stack);
      _isSyncing = false;
      _notifyStatus(SyncState.error, error: e.toString());
    }
  }

  void _notifyStatus(SyncState state, {String? error}) async {
    final pendingCount = await queueManager.getPendingCount();
    _statusController.add(
      SyncStatus(
        state: state,
        pendingItemsCount: pendingCount,
        lastError: error,
        lastSyncTime: _lastSyncTime,
      ),
    );
  }

  void dispose() {
    _periodicTimer?.cancel();
    _statusController.close();
  }
}
