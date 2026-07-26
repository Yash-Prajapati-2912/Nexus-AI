import 'package:equatable/equatable.dart';

class LanguageEntity extends Equatable {
  final String languageCode;
  final String regionCode;
  final String dateFormat;
  final String timeFormat;
  final String numberFormat;
  final String timezone;

  const LanguageEntity({
    required this.languageCode,
    required this.regionCode,
    required this.dateFormat,
    required this.timeFormat,
    required this.numberFormat,
    required this.timezone,
  });

  factory LanguageEntity.initial() {
    return const LanguageEntity(
      languageCode: 'en',
      regionCode: 'US',
      dateFormat: 'yyyy-MM-dd',
      timeFormat: '24h',
      numberFormat: 'standard',
      timezone: 'UTC',
    );
  }

  LanguageEntity copyWith({
    String? languageCode,
    String? regionCode,
    String? dateFormat,
    String? timeFormat,
    String? numberFormat,
    String? timezone,
  }) {
    return LanguageEntity(
      languageCode: languageCode ?? this.languageCode,
      regionCode: regionCode ?? this.regionCode,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      numberFormat: numberFormat ?? this.numberFormat,
      timezone: timezone ?? this.timezone,
    );
  }

  @override
  List<Object?> get props => [
        languageCode,
        regionCode,
        dateFormat,
        timeFormat,
        numberFormat,
        timezone,
      ];
}
