import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high, urgent }
enum TaskStatus { pending, inProgress, completed, archived }

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final String? category;
  final bool isRecurring;
  final List<String>? subtasks;
  final List<String>? requirements;
  final String? timeAllocationHint;
  final String? priorityReasoning;
  final Map<String, dynamic>? metadata;

  const TaskEntity({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    this.category,
    this.isRecurring = false,
    this.subtasks,
    this.requirements,
    this.timeAllocationHint,
    this.priorityReasoning,
    this.metadata,
  });

  // Dynamic getters extracted from structured metadata
  String get documentType {
    if (metadata?['classification'] is Map) {
      return (metadata!['classification']['documentType'] as String?)?.toUpperCase() ?? 'OTHER';
    }
    return (metadata?['documentType'] as String?)?.toUpperCase() ?? 'OTHER';
  }

  String get topLevelCategory {
    if (metadata?['classification'] is Map) {
      return (metadata!['classification']['topLevelCategory'] as String?) ?? (category ?? 'Assignments & Coursework');
    }
    return (metadata?['topLevelCategory'] as String?) ?? (category ?? 'Assignments & Coursework');
  }

  String get subject {
    if (metadata?['classification'] is Map) {
      return (metadata!['classification']['subject'] as String?) ?? 'General Academic';
    }
    return (metadata?['subject'] as String?) ?? 'General Academic';
  }

  String get subCategory => documentType;

  String get documentPurpose {
    if (metadata?['classification'] is Map) {
      return (metadata!['classification']['documentPurpose'] as String?) ?? '';
    }
    return (metadata?['documentPurpose'] as String?) ?? '';
  }

  double get confidence {
    if (metadata?['classification'] is Map && metadata!['classification']['confidence'] is num) {
      return (metadata!['classification']['confidence'] as num).toDouble();
    }
    if (metadata?['confidence'] is num) {
      return (metadata!['confidence'] as num).toDouble();
    }
    return 0.85;
  }

  bool get containsActionableWork {
    if (metadata?['classification'] is Map) {
      return (metadata!['classification']['containsActionableWork'] as bool?) ?? true;
    }
    return (metadata?['containsActionableWork'] as bool?) ?? true;
  }

  bool get isResourceOnly => !containsActionableWork;

  String? get sourceFileName => metadata?['sourceFileName'] as String?;
  String? get summary => metadata?['summary'] as String?;
  String? get whatWeAreGoingToDo => description;
  String? get whyThisTaskExists => priorityReasoning ?? documentPurpose;

  List<String> get classificationEvidence {
    if (metadata?['classification'] is Map && metadata!['classification']['classificationEvidence'] is List) {
      return (metadata!['classification']['classificationEvidence'] as List).map((e) => e.toString()).toList();
    }
    if (metadata?['classificationEvidence'] is List) {
      return (metadata!['classificationEvidence'] as List).map((e) => e.toString()).toList();
    }
    return [];
  }

  List<String> get taskEvidence {
    if (metadata?['taskEvidence'] is List) {
      return (metadata!['taskEvidence'] as List).map((e) => e.toString()).toList();
    }
    return [];
  }

  List<String> get documentFacts {
    if (metadata?['documentFacts'] is List) {
      return (metadata!['documentFacts'] as List).map((e) => e.toString()).toList();
    }
    return [];
  }

  List<String> get aiRecommendations {
    if (metadata?['aiRecommendations'] is List) {
      return (metadata!['aiRecommendations'] as List).map((e) => e.toString()).toList();
    }
    return [];
  }

  List<String> get deliverables {
    if (metadata?['deliverables'] is List) {
      return (metadata!['deliverables'] as List).map((e) => e.toString()).toList();
    }
    return [];
  }

  List<String> get suggestedResources {
    if (metadata?['suggestedResources'] is List) {
      return (metadata!['suggestedResources'] as List).map((e) => e.toString()).toList();
    }
    return [];
  }

  List<String> get recommendations {
    if (metadata?['recommendations'] is List) {
      return (metadata!['recommendations'] as List).map((e) => e.toString()).toList();
    }
    return [];
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dueDate,
        priority,
        status,
        category,
        isRecurring,
        subtasks,
        requirements,
        timeAllocationHint,
        priorityReasoning,
        metadata,
      ];
}
