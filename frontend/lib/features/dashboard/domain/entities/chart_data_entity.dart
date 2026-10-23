import 'package:equatable/equatable.dart';

class ChartDataPoint extends Equatable {
  final String label;
  final double value;

  const ChartDataPoint({required this.label, required this.value});

  @override
  List<Object?> get props => [label, value];
}

class ChartDataEntity extends Equatable {
  final List<ChartDataPoint> weeklyStudyHours;
  final List<ChartDataPoint> categoryExpenses;
  final List<ChartDataPoint> taskCompletionTrend;

  const ChartDataEntity({
    required this.weeklyStudyHours,
    required this.categoryExpenses,
    required this.taskCompletionTrend,
  });

  @override
  List<Object?> get props => [
        weeklyStudyHours,
        categoryExpenses,
        taskCompletionTrend,
      ];

  ChartDataEntity copyWith({
    List<ChartDataPoint>? weeklyStudyHours,
    List<ChartDataPoint>? categoryExpenses,
    List<ChartDataPoint>? taskCompletionTrend,
  }) {
    return ChartDataEntity(
      weeklyStudyHours: weeklyStudyHours ?? this.weeklyStudyHours,
      categoryExpenses: categoryExpenses ?? this.categoryExpenses,
      taskCompletionTrend: taskCompletionTrend ?? this.taskCompletionTrend,
    );
  }
}
