import 'package:equatable/equatable.dart';

class AIPreferencesEntity extends Equatable {
  final String personality;
  final String responseStyle;
  final String responseLength;
  final String preferredLanguage;
  final bool streamingResponses;
  final bool contextMemoryEnabled;
  final bool suggestionsEnabled;

  const AIPreferencesEntity({
    required this.personality,
    required this.responseStyle,
    required this.responseLength,
    required this.preferredLanguage,
    required this.streamingResponses,
    required this.contextMemoryEnabled,
    required this.suggestionsEnabled,
  });

  factory AIPreferencesEntity.initial() {
    return const AIPreferencesEntity(
      personality: 'Professional',
      responseStyle: 'BALANCED',
      responseLength: 'Medium',
      preferredLanguage: 'English',
      streamingResponses: true,
      contextMemoryEnabled: true,
      suggestionsEnabled: true,
    );
  }

  AIPreferencesEntity copyWith({
    String? personality,
    String? responseStyle,
    String? responseLength,
    String? preferredLanguage,
    bool? streamingResponses,
    bool? contextMemoryEnabled,
    bool? suggestionsEnabled,
  }) {
    return AIPreferencesEntity(
      personality: personality ?? this.personality,
      responseStyle: responseStyle ?? this.responseStyle,
      responseLength: responseLength ?? this.responseLength,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      streamingResponses: streamingResponses ?? this.streamingResponses,
      contextMemoryEnabled: contextMemoryEnabled ?? this.contextMemoryEnabled,
      suggestionsEnabled: suggestionsEnabled ?? this.suggestionsEnabled,
    );
  }

  @override
  List<Object?> get props => [
        personality,
        responseStyle,
        responseLength,
        preferredLanguage,
        streamingResponses,
        contextMemoryEnabled,
        suggestionsEnabled,
      ];
}
