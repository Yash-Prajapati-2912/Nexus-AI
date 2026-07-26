import '../../domain/entities/prompt_template.dart';

class PromptTemplateModel extends PromptTemplate {
  const PromptTemplateModel({
    required super.id,
    required super.title,
    required super.category,
    required super.promptText,
    super.isFavorite,
    super.usageCount,
  });

  factory PromptTemplateModel.fromJson(Map<String, dynamic> json) {
    return PromptTemplateModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Prompt',
      category: json['category'] as String? ?? 'GENERAL',
      promptText: json['promptText'] as String? ?? json['prompt'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      usageCount: json['usageCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'promptText': promptText,
      'isFavorite': isFavorite,
      'usageCount': usageCount,
    };
  }
}
