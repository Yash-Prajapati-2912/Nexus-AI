import '../../domain/entities/language_entity.dart';

class LanguageModel extends LanguageEntity {
  const LanguageModel({
    required super.languageCode,
    required super.regionCode,
    required super.dateFormat,
    required super.timeFormat,
    required super.numberFormat,
    required super.timezone,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    final lang = json['language'] as String? ?? 'en-US';
    final parts = lang.contains('-') ? lang.split('-') : [lang, 'US'];

    return LanguageModel(
      languageCode: json['languageCode'] as String? ?? parts[0],
      regionCode: json['regionCode'] as String? ?? (parts.length > 1 ? parts[1] : 'US'),
      dateFormat: json['dateFormat'] as String? ?? 'yyyy-MM-dd',
      timeFormat: json['timeFormat'] as String? ?? '24h',
      numberFormat: json['numberFormat'] as String? ?? 'standard',
      timezone: json['timezone'] as String? ?? 'UTC',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': '$languageCode-$regionCode',
      'languageCode': languageCode,
      'regionCode': regionCode,
      'dateFormat': dateFormat,
      'timeFormat': timeFormat,
      'numberFormat': numberFormat,
      'timezone': timezone,
    };
  }

  factory LanguageModel.fromEntity(LanguageEntity entity) {
    return LanguageModel(
      languageCode: entity.languageCode,
      regionCode: entity.regionCode,
      dateFormat: entity.dateFormat,
      timeFormat: entity.timeFormat,
      numberFormat: entity.numberFormat,
      timezone: entity.timezone,
    );
  }
}
