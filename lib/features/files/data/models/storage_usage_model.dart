import '../../domain/entities/storage_usage.dart';

class StorageUsageModel extends StorageUsage {
  const StorageUsageModel({
    required super.usedBytes,
    required super.totalBytes,
    required super.imagesBytes,
    required super.documentsBytes,
    required super.mediaBytes,
    required super.otherBytes,
    required super.fileCount,
  });

  factory StorageUsageModel.fromJson(Map<String, dynamic> json) {
    return StorageUsageModel(
      usedBytes: json['usedBytes'] as int? ?? 145000000, // ~145 MB
      totalBytes: json['totalBytes'] as int? ?? 10737418240, // 10 GB
      imagesBytes: json['imagesBytes'] as int? ?? 45000000,
      documentsBytes: json['documentsBytes'] as int? ?? 65000000,
      mediaBytes: json['mediaBytes'] as int? ?? 25000000,
      otherBytes: json['otherBytes'] as int? ?? 10000000,
      fileCount: json['fileCount'] as int? ?? 32,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usedBytes': usedBytes,
      'totalBytes': totalBytes,
      'imagesBytes': imagesBytes,
      'documentsBytes': documentsBytes,
      'mediaBytes': mediaBytes,
      'otherBytes': otherBytes,
      'fileCount': fileCount,
    };
  }
}
