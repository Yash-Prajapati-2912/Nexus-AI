import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection_container.dart';
import '../../../../shared/design_system/widgets/buttons/app_primary_button.dart';
import '../../../../shared/design_system/widgets/inputs/app_text_field.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/services/academic_document_classifier.dart';
import '../bloc/planner_bloc.dart';
import '../bloc/planner_event.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Manual Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _subjectController = TextEditingController(text: 'General Academic');
  String _selectedCategory = 'Assignments & Coursework';
  TaskPriority _priority = TaskPriority.medium;
  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 2));

  // Auto-Detect Controllers & State
  final _documentTextController = TextEditingController();
  String? _selectedFileName;
  bool _isAnalyzing = false;
  String? _extractionError;
  ClassifiedDocumentResult? _classifiedResult;
  PdfExtractionQualityResult? _pdfQualityResult;

  final List<String> _categoryOptions = [
    'Assignments & Coursework',
    'Exam Preparation',
    'Study Materials',
    'Projects',
    'Practical & Lab',
    'Other',
  ];

  PlannerBloc _getPlannerBloc() {
    try {
      return context.read<PlannerBloc>();
    } catch (_) {
      return getIt<PlannerBloc>();
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _subjectController.dispose();
    _documentTextController.dispose();
    super.dispose();
  }

  // File Picker method
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'pdf', 'doc', 'docx', 'md', 'json'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final filename = file.name;

        setState(() {
          _selectedFileName = filename;
          _extractionError = null;
          _classifiedResult = null;
          _pdfQualityResult = null;
        });

        PdfExtractionQualityResult qualityResult;
        if (file.bytes != null) {
          qualityResult = AcademicDocumentClassifierService.extractAndValidatePdfText(file.bytes!, filename);
        } else if (file.path != null) {
          final bytes = await File(file.path!).readAsBytes();
          qualityResult = AcademicDocumentClassifierService.extractAndValidatePdfText(bytes, filename);
        } else {
          qualityResult = const PdfExtractionQualityResult(
            text: '',
            pageCount: 0,
            characterCount: 0,
            isValid: false,
            isScanned: true,
            extractionStatus: 'UNREADABLE PDF',
            failureReason: 'We couldn\'t understand this document. Please try another readable document.',
          );
        }

        setState(() {
          _pdfQualityResult = qualityResult;
        });

        if (qualityResult.isValid) {
          _documentTextController.text = qualityResult.text;
          await _analyzeDocumentWithAi(text: qualityResult.text, filename: filename);
        } else {
          _documentTextController.clear();
          setState(() {
            _extractionError = 'We couldn\'t understand this document. Please try another readable document.';
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _extractionError = 'We couldn\'t understand this document. Please try another readable document.';
      });
    }
  }

  // Trigger AI Auto-Extract on File Data
  Future<void> _analyzeDocumentWithAi({String? text, String? filename}) async {
    final docText = text ?? _documentTextController.text.trim();
    final docFn = filename ?? _selectedFileName;

    if (docText.isEmpty && docFn == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a file or paste document text first')),
      );
      return;
    }

    if (_pdfQualityResult != null && !_pdfQualityResult!.isValid) {
      setState(() {
        _extractionError = 'We couldn\'t understand this document. Please try another readable document.';
        _classifiedResult = null;
      });
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _extractionError = null;
      _classifiedResult = null;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    final result = AcademicDocumentClassifierService.classifyDocumentContent(
      text: docText,
      filename: docFn,
    );

    setState(() {
      _isAnalyzing = false;
      _classifiedResult = result;
    });
  }

  bool _isSaving = false;

  void _saveManualTask() {
    if (_isSaving) return;
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);
      final newTask = TaskEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descController.text.trim().isNotEmpty ? _descController.text.trim() : null,
        dueDate: _selectedDueDate,
        priority: _priority,
        status: TaskStatus.pending,
        category: _selectedCategory,
        metadata: {
          'subject': _subjectController.text.trim().isNotEmpty ? _subjectController.text.trim() : 'General Academic',
          'topLevelCategory': _selectedCategory,
        },
      );
      _getPlannerBloc().add(CreateTaskEvent(newTask));
      Navigator.of(context).pop();
    }
  }

  void _saveAiTask() {
    if (_isSaving) return;
    if (_classifiedResult == null || _classifiedResult!.tasks.isEmpty) return;
    setState(() => _isSaving = true);
    final res = _classifiedResult!;
    final bloc = _getPlannerBloc();

    final categoryString = DocumentClassification.topLevelCategoryToString(res.classification.topLevelCategory);

    for (final t in res.tasks) {
      final taskEntity = TaskEntity(
        id: '${DateTime.now().millisecondsSinceEpoch}_${t.title.hashCode}',
        title: t.title,
        description: t.description,
        category: categoryString,
        dueDate: t.deadline ?? DateTime.now().add(const Duration(days: 4)),
        priority: t.priority.toUpperCase() == 'HIGH'
            ? TaskPriority.high
            : (t.priority.toUpperCase() == 'LOW' ? TaskPriority.low : TaskPriority.medium),
        status: TaskStatus.pending,
        subtasks: t.actionSteps,
        requirements: t.prerequisites,
        timeAllocationHint: t.estimatedTimeReason,
        priorityReasoning: t.priorityReason,
        metadata: {
          ...res.toJson(),
          'taskEvidence': t.taskEvidence,
          'documentFacts': t.documentFacts,
          'aiRecommendations': t.aiRecommendations,
          'deliverables': t.deliverables,
        },
      );
      bloc.add(CreateTaskEvent(taskEntity));
    }

    final message = res.tasks.length > 1
        ? '✨ ${res.tasks.length} Tasks Created Successfully!'
        : '✨ Task Created Successfully under "${res.classification.subject}"!';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    Navigator.of(context).pop();
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Create Academic Task', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.indigoAccent,
          labelColor: Colors.indigoAccent,
          unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Poppins'),
          tabs: const [
            Tab(
              icon: Icon(Icons.auto_awesome_rounded, size: 18),
              text: 'Analyze Document',
            ),
            Tab(
              icon: Icon(Icons.add_task_rounded, size: 18),
              text: 'Add Manually',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // FLOW A: ANALYZE DOCUMENT WITH AI
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, color: Colors.indigoAccent, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Academic Document Analyzer',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDark ? Colors.white : Colors.indigo[900],
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Upload your assignment, syllabus, or notes PDF to auto-detect tasks, due dates, and study priorities.',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white70 : Colors.black54,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Upload Dropzone
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.02),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.indigoAccent.withValues(alpha: 0.4) : Colors.indigo.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.cloud_upload_outlined, color: Colors.indigoAccent, size: 40),
                        const SizedBox(height: 10),
                        Text(
                          _selectedFileName != null
                              ? '📄 Selected File: $_selectedFileName'
                              : 'Tap to upload Document or PDF',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black87,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Supports PDF, DOCX, TXT',
                          style: TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text('OR PASTE TEXT BELOW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _documentTextController,
                  label: 'Document Content / Assignment Details',
                  hint: 'Paste task details or syllabus dates here...',
                  maxLines: 4,
                ),
                const SizedBox(height: 20),
                AppPrimaryButton(
                  label: _isAnalyzing ? 'Analyzing Document...' : '⚡ Analyze Document',
                  onPressed: _isAnalyzing ? null : () => _analyzeDocumentWithAi(),
                ),

                if (_extractionError != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.redAccent, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _extractionError!,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (_isAnalyzing) ...[
                  const SizedBox(height: 24),
                  const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: Colors.indigoAccent),
                        SizedBox(height: 12),
                        Text('Analyzing document...', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],

                if (_classifiedResult != null && !_isAnalyzing) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.indigo.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: Colors.green, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Analysis Completed',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green, fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Detected Subject: ${_classifiedResult!.classification.subject}',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87, fontFamily: 'Poppins'),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Category: ${DocumentClassification.topLevelCategoryToString(_classifiedResult!.classification.topLevelCategory)}',
                          style: const TextStyle(fontSize: 12, color: Colors.indigoAccent, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${_classifiedResult!.taskCount} task${_classifiedResult!.taskCount == 1 ? "" : "s"} detected:',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Poppins'),
                        ),
                        const SizedBox(height: 10),
                        ..._classifiedResult!.tasks.map((t) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigoAccent, fontSize: 14)),
                              Expanded(
                                child: Text(
                                  t.title,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, fontFamily: 'Poppins'),
                                ),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 20),
                        AppPrimaryButton(
                          label: _classifiedResult!.taskCount > 1
                              ? 'Confirm & Save ${_classifiedResult!.taskCount} Tasks'
                              : 'Confirm & Save Task',
                          onPressed: _saveAiTask,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // FLOW B: ADD MANUALLY
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _titleController,
                    label: 'Task Title',
                    hint: 'e.g. EEJS Assignment 1 Presentation',
                    validator: (val) => val == null || val.trim().isEmpty ? 'Please enter task title' : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _subjectController,
                    label: 'Subject / Course Code',
                    hint: 'e.g. EEJS, Data Structures',
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                    items: _categoryOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TaskPriority>(
                    value: _priority,
                    decoration: const InputDecoration(labelText: 'Priority', border: OutlineInputBorder()),
                    items: TaskPriority.values
                        .map((p) => DropdownMenuItem(value: p, child: Text(p.name.toUpperCase())))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _priority = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _selectDueDate,
                    borderRadius: BorderRadius.circular(8),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Due Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_month_rounded, color: Colors.indigoAccent),
                      ),
                      child: Text(
                        '${_selectedDueDate.day}/${_selectedDueDate.month}/${_selectedDueDate.year}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _descController,
                    label: 'Description / Task Objectives (Optional)',
                    hint: 'Enter specific task requirements or instructions...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 28),
                  AppPrimaryButton(
                    label: 'Create Task',
                    onPressed: _saveManualTask,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
