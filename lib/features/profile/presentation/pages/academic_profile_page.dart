import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/academic_profile.dart';
import '../bloc/profile_bloc.dart';

class AcademicProfilePage extends StatefulWidget {
  const AcademicProfilePage({super.key});

  @override
  State<AcademicProfilePage> createState() => _AcademicProfilePageState();
}

class _AcademicProfilePageState extends State<AcademicProfilePage> {
  late TextEditingController _uniController;
  late TextEditingController _degreeController;
  late TextEditingController _branchController;
  late TextEditingController _semesterController;
  late TextEditingController _gradYearController;
  late TextEditingController _cgpaController;
  late TextEditingController _skillsController;
  late TextEditingController _interestsController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _uniController = TextEditingController();
    _degreeController = TextEditingController();
    _branchController = TextEditingController();
    _semesterController = TextEditingController();
    _gradYearController = TextEditingController();
    _cgpaController = TextEditingController();
    _skillsController = TextEditingController();
    _interestsController = TextEditingController();

    final initialState = context.read<ProfileBloc>().state;
    if (initialState is ProfileLoadedState) {
      _populateControllers(initialState.academic);
    }
  }

  void _populateControllers(AcademicProfile acad) {
    if (!_initialized) {
      _uniController.text = acad.university;
      _degreeController.text = acad.degree;
      _branchController.text = acad.branch;
      _semesterController.text = acad.semester > 0 ? acad.semester.toString() : '';
      _gradYearController.text = acad.graduationYear > 0 ? acad.graduationYear.toString() : '';
      _cgpaController.text = acad.cgpa > 0 ? acad.cgpa.toString() : '';
      _skillsController.text = acad.skills.join(', ');
      _interestsController.text = acad.careerInterests.join(', ');
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _uniController.dispose();
    _degreeController.dispose();
    _branchController.dispose();
    _semesterController.dispose();
    _gradYearController.dispose();
    _cgpaController.dispose();
    _skillsController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  void _saveAcademic() {
    final parsedSemester = int.tryParse(_semesterController.text.trim()) ?? 0;
    final parsedGradYear = int.tryParse(_gradYearController.text.trim()) ?? 0;
    final parsedCgpa = double.tryParse(_cgpaController.text.trim()) ?? 0.0;

    final skillsList = _skillsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final interestsList = _interestsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final payload = <String, dynamic>{
      'university': _uniController.text.trim(),
      'degree': _degreeController.text.trim(),
      'branch': _branchController.text.trim(),
      'department': _branchController.text.trim(),
      'semester': parsedSemester,
      'graduationYear': parsedGradYear,
      'cgpa': parsedCgpa,
      'skills': skillsList,
      'careerInterests': interestsList,
    };

    context.read<ProfileBloc>().add(UpdateAcademicEvent(payload));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Academic Profile updated successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoadedState) {
          _populateControllers(state.academic);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Academic Details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: _saveAcademic,
              tooltip: 'Save Academic Info',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _uniController,
                decoration: const InputDecoration(
                  labelText: 'University / Institution',
                  prefixIcon: Icon(Icons.school_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _degreeController,
                decoration: const InputDecoration(
                  labelText: 'Degree / Program (e.g. B.Tech, M.S.)',
                  prefixIcon: Icon(Icons.workspace_premium_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _branchController,
                decoration: const InputDecoration(
                  labelText: 'Branch / Major (e.g. Computer Science)',
                  prefixIcon: Icon(Icons.account_tree_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _semesterController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Current Semester',
                        prefixIcon: Icon(Icons.format_list_numbered_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _gradYearController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Graduation Year',
                        prefixIcon: Icon(Icons.calendar_today_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cgpaController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Current CGPA / GPA',
                  prefixIcon: Icon(Icons.bar_chart_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _skillsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Technical & Academic Skills',
                  prefixIcon: Icon(Icons.code_rounded),
                  helperText: 'Separate skills with commas (e.g. Flutter, Dart, NestJS)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _interestsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Career & Learning Interests',
                  prefixIcon: Icon(Icons.stars_rounded),
                  helperText: 'Separate interests with commas (e.g. AI Architecture, ML)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveAcademic,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Academic Info'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
