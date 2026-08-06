import '../../domain/entities/academic_profile.dart';

class AcademicProfileModel extends AcademicProfile {
  const AcademicProfileModel({
    required super.id,
    required super.university,
    required super.college,
    required super.degree,
    required super.branch,
    required super.semester,
    required super.currentYear,
    required super.cgpa,
    required super.graduationYear,
    required super.subjects,
    required super.skills,
    required super.careerInterests,
  });

  factory AcademicProfileModel.fromJson(Map<String, dynamic> json) {
    final rawSubs = json['subjects'] as List<dynamic>? ?? [];
    final rawSkills = json['skills'] as List<dynamic>? ?? [];
    final rawInterests = json['careerGoals'] as List<dynamic>? ?? json['careerInterests'] as List<dynamic>? ?? [];

    final sem = json['semester'] as int? ?? 0;
    final yearFromSem = sem > 0 ? (sem + 1) ~/ 2 : 0;
    final yearVal = (json['currentYear'] as int? ?? 0) > 0
        ? (json['currentYear'] as int)
        : yearFromSem;

    final parsedSkills = rawSkills.map((e) {
      if (e is Map<String, dynamic>) {
        return e['name'] as String? ?? '';
      }
      return e.toString();
    }).where((s) => s.trim().isNotEmpty).toList();

    final parsedInterests = rawInterests.map((e) {
      if (e is Map<String, dynamic>) {
        return e['title'] as String? ?? e['name'] as String? ?? '';
      }
      return e.toString();
    }).where((s) => s.trim().isNotEmpty).toList();

    return AcademicProfileModel(
      id: json['id'] as String? ?? '',
      university: json['university'] as String? ?? json['institution'] as String? ?? '',
      college: json['college'] as String? ?? '',
      degree: json['degree'] as String? ?? '',
      branch: json['branch'] as String? ?? json['department'] as String? ?? '',
      semester: sem,
      currentYear: yearVal,
      cgpa: (json['cgpa'] as num?)?.toDouble() ?? 0.0,
      graduationYear: json['graduationYear'] as int? ?? 0,
      subjects: rawSubs.map((e) => e.toString()).toList(),
      skills: parsedSkills,
      careerInterests: parsedInterests,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university': university,
      'college': college,
      'degree': degree,
      'branch': branch,
      'semester': semester,
      'currentYear': currentYear,
      'cgpa': cgpa,
      'graduationYear': graduationYear,
      'subjects': subjects,
      'skills': skills,
      'careerInterests': careerInterests,
    };
  }
}
