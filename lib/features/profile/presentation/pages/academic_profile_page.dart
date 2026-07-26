import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';

class AcademicProfilePage extends StatefulWidget {
  const AcademicProfilePage({super.key});

  @override
  State<AcademicProfilePage> createState() => _AcademicProfilePageState();
}

class _AcademicProfilePageState extends State<AcademicProfilePage> {
  final _uniController = TextEditingController(text: 'Stanford University');
  final _degreeController = TextEditingController(text: 'Bachelor of Science');
  final _branchController = TextEditingController(text: 'Computer Science');
  final _cgpaController = TextEditingController(text: '3.85');

  @override
  void dispose() {
    _uniController.dispose();
    _degreeController.dispose();
    _branchController.dispose();
    _cgpaController.dispose();
    super.dispose();
  }

  void _saveAcademic() {
    context.read<ProfileBloc>().add(UpdateAcademicEvent({
          'university': _uniController.text.trim(),
          'degree': _degreeController.text.trim(),
          'branch': _branchController.text.trim(),
          'cgpa': double.tryParse(_cgpaController.text.trim()) ?? 3.85,
        }));

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Academic Profile updated!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.check_rounded), onPressed: _saveAcademic),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _uniController,
              decoration: const InputDecoration(labelText: 'University / Institute', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _degreeController,
              decoration: const InputDecoration(labelText: 'Degree', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _branchController,
              decoration: const InputDecoration(labelText: 'Branch / Major', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cgpaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Current CGPA / GPA', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }
}
