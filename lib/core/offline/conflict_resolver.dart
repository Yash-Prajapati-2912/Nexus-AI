import '../services/app_logger.dart';

enum ConflictStrategy { serverWins, clientWins, timestampBased, manualMerge }

class ConflictResolver {
  final ConflictStrategy defaultStrategy;

  ConflictResolver({this.defaultStrategy = ConflictStrategy.timestampBased});

  Map<String, dynamic> resolve({
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    ConflictStrategy? strategy,
  }) {
    final activeStrategy = strategy ?? defaultStrategy;

    switch (activeStrategy) {
      case ConflictStrategy.serverWins:
        AppLogger.info('ConflictResolver: Resolved conflict using Server-Wins strategy.');
        return Map<String, dynamic>.from(remoteData);

      case ConflictStrategy.clientWins:
        AppLogger.info('ConflictResolver: Resolved conflict using Client-Wins strategy.');
        return Map<String, dynamic>.from(localData);

      case ConflictStrategy.timestampBased:
        final localTime = _extractTimestamp(localData);
        final remoteTime = _extractTimestamp(remoteData);

        if (remoteTime.isAfter(localTime)) {
          AppLogger.info('ConflictResolver: Remote data newer ($remoteTime > $localTime). Server-Wins applied.');
          return Map<String, dynamic>.from(remoteData);
        } else {
          AppLogger.info('ConflictResolver: Local data newer ($localTime >= $remoteTime). Client-Wins applied.');
          return Map<String, dynamic>.from(localData);
        }

      case ConflictStrategy.manualMerge:
        final merged = Map<String, dynamic>.from(remoteData);
        localData.forEach((key, value) {
          if (value != null && (!merged.containsKey(key) || merged[key] == null)) {
            merged[key] = value;
          }
        });
        AppLogger.info('ConflictResolver: Resolved conflict using Manual-Merge strategy.');
        return merged;
    }
  }

  DateTime _extractTimestamp(Map<String, dynamic> data) {
    if (data.containsKey('updatedAt') && data['updatedAt'] != null) {
      return DateTime.tryParse(data['updatedAt'].toString()) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    if (data.containsKey('timestamp') && data['timestamp'] != null) {
      return DateTime.tryParse(data['timestamp'].toString()) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
