import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/planner/domain/services/academic_document_classifier.dart';

void main() {
  group('AcademicDocumentClassifierService Regression Tests', () {
    test('EEJS assignment document should classify as assignmentCollection and segment into 4 tasks', () {
      const sampleText = '''
        Course: Employability & Job Skills (EEJS) - 1010343482
        Instructions for Students:
        Assignment 1: Conduct a presentation on a topic of your choice.
        Assignment 2: Research target job role responsibilities & prepare interview Q&A.
        Assignment 3: Develop list of common interview questions & model answers.
        Assignment 4: Draft professional resume highlighting skills/experience OR job cover letter.
      ''';

      final result = AcademicDocumentClassifierService.classifyDocumentContent(
        text: sampleText,
        filename: 'EEJS_Assignment_Sheet.pdf',
      );

      expect(result.classification.documentType, AcademicDocumentType.assignmentCollection);
      expect(result.classification.topLevelCategory, AcademicTopLevelCategory.assignmentsAndCoursework);
      expect(result.tasks.length, 4);
      expect(result.tasks[0].title, contains('Presentation Skills'));
      expect(result.tasks[1].title, contains('Job Role Research & Q&A'));
      expect(result.tasks[2].title, contains('Common Interview Q&A List'));
      expect(result.tasks[3].title, contains('Resume & Cover Letter Drafting'));
    });

    test('EEJS syllabus document must classify as Syllabus under Exam Preparation and NOT produce 4 tasks', () {
      const sampleText = '''
        Course Syllabus: EEJS 1010343482
        Teaching Scheme & Course Outline
        Unit 1: Self-Assessment & Goal Setting
        Unit 2: Communication Skills & Group Discussions
        Unit 3: Resume Writing & Interview Preparation
        Course Outcomes & Reference Books
      ''';

      final result = AcademicDocumentClassifierService.classifyDocumentContent(
        text: sampleText,
        filename: 'EEJS_Syllabus.pdf',
      );

      expect(result.classification.documentType, AcademicDocumentType.syllabus);
      expect(result.classification.topLevelCategory, AcademicTopLevelCategory.examPreparation);
      expect(result.tasks.length, 1);
      expect(result.tasks[0].taskType, 'SYLLABUS');
      expect(result.tasks[0].title, contains('EEJS Syllabus'));
    });

    test('Unclassified text gracefully defaults to other academic without failing', () {
      const sampleText = 'General notes regarding campus library hours and rules.';
      final result = AcademicDocumentClassifierService.classifyDocumentContent(
        text: sampleText,
        filename: 'library_info.txt',
      );

      expect(result.classification.documentType, AcademicDocumentType.other);
      expect(result.classification.containsActionableWork, false);
    });
  });
}
