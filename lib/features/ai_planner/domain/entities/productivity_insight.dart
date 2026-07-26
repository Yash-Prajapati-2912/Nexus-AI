import 'package:equatable/equatable.dart';

/// Domain entity for Productivity Insights data.
class ProductivityInsight extends Equatable {
  final int studyStreakDays;
  final String bestStudyHours; // e.g. "08:00 AM - 11:00 AM"
  final double focusTimeHours;
  final double completionRatePercentage;
  final double productivityScore; // 0 to 100
  final List<double> weeklyTrends; // 7 days values
  final List<double> monthlyTrends; // 4 weeks values
  final List<String> keyTakeaways;

  const ProductivityInsight({
    required this.studyStreakDays,
    required this.bestStudyHours,
    required this.focusTimeHours,
    required this.completionRatePercentage,
    required this.productivityScore,
    required this.weeklyTrends,
    required this.monthlyTrends,
    required this.keyTakeaways,
  });

  @override
  List<Object?> get props => [
        studyStreakDays,
        bestStudyHours,
        focusTimeHours,
        completionRatePercentage,
        productivityScore,
        weeklyTrends,
        monthlyTrends,
        keyTakeaways,
      ];
}
