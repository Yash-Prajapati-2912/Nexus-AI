import 'package:equatable/equatable.dart';

/// Domain entity representing academic information.
class AcademicProfile extends Equatable {
  final String id;
  final String university;
  final String college;
  final String degree;
  final String branch;
  final int semester;
  final int currentYear;
  final double cgpa;
  final int graduationYear;
  final List<String> subjects;
  final List<String> skills;
  final List<String> careerInterests;

  const AcademicProfile({
    required this.id,
    required this.university,
    required this.college,
    required this.degree,
    required this.branch,
    required this.semester,
    required this.currentYear,
    required this.cgpa,
    required this.graduationYear,
    required this.subjects,
    required this.skills,
    required this.careerInterests,
  });

  @override
  List<Object?> get props => [
        id,
        university,
        college,
        degree,
        branch,
        semester,
        currentYear,
        cgpa,
        graduationYear,
        subjects,
        skills,
        careerInterests,
      ];
}
