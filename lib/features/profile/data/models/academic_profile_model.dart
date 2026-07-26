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
    final rawSubs = json['subjects'] as List<dynamic>? ?? ['Data Structures', 'Algorithms', 'Database Systems', 'AI & ML'];
    final rawSkills = json['skills'] as List<dynamic>? ?? ['Flutter', 'Dart', 'TypeScript', 'NestJS', 'Python'];
    final rawInterests = json['careerInterests'] as List<dynamic>? ?? ['Software Engineering', 'AI Architecture', 'Cloud Systems'];

    return AcademicProfileModel(
      id: json['id'] as String? ?? 'acad1',
      university: json['university'] as String? ?? 'Stanford University',
      college: json['college'] as String? ?? 'School of Engineering',
      degree: json['degree'] as String? ?? 'Bachelor of Science',
      branch: json['branch'] as String? ?? 'Computer Science',
      semester: json['semester'] as int? ?? 6,
      currentYear: json['currentYear'] as int? ?? 3,
      cgpa: (json['cgpa'] as num?)?.toDouble() ?? 3.85,
      graduationYear: json['graduationYear'] as int? ?? 2027,
      subjects: rawSubs.map((e) => e.toString()).toList(),
      skills: rawSkills.map((e) => e.toString()).toList(),
      careerInterests: rawInterests.map((e) => e.toString()).toList(),
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
