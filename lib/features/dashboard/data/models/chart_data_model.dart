import '../../domain/entities/chart_data_entity.dart';

class ChartDataPointModel {
  final String label;
  final double value;

  const ChartDataPointModel({required this.label, required this.value});

  factory ChartDataPointModel.fromJson(Map<String, dynamic> json) {
    return ChartDataPointModel(
      label: json['label'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {'label': label, 'value': value};

  ChartDataPoint toDomain() => ChartDataPoint(label: label, value: value);
}

class ChartDataModel {
  final List<ChartDataPointModel> weeklyStudyHours;
  final List<ChartDataPointModel> categoryExpenses;
  final List<ChartDataPointModel> taskCompletionTrend;

  const ChartDataModel({
    required this.weeklyStudyHours,
    required this.categoryExpenses,
    required this.taskCompletionTrend,
  });

  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    List<ChartDataPointModel> parsePoints(String key) {
      return (json[key] as List<dynamic>?)
              ?.map((e) => ChartDataPointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    }

    return ChartDataModel(
      weeklyStudyHours: parsePoints('weeklyStudyHours'),
      categoryExpenses: parsePoints('categoryExpenses'),
      taskCompletionTrend: parsePoints('taskCompletionTrend'),
    );
  }

  Map<String, dynamic> toJson() => {
        'weeklyStudyHours': weeklyStudyHours.map((e) => e.toJson()).toList(),
        'categoryExpenses': categoryExpenses.map((e) => e.toJson()).toList(),
        'taskCompletionTrend': taskCompletionTrend.map((e) => e.toJson()).toList(),
      };

  ChartDataEntity toDomain() {
    return ChartDataEntity(
      weeklyStudyHours: weeklyStudyHours.map((e) => e.toDomain()).toList(),
      categoryExpenses: categoryExpenses.map((e) => e.toDomain()).toList(),
      taskCompletionTrend: taskCompletionTrend.map((e) => e.toDomain()).toList(),
    );
  }
}
