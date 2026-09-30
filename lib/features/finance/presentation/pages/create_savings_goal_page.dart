import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../domain/entities/savings_goal.dart';
import '../bloc/savings_bloc.dart';
import '../bloc/savings_event.dart';
import '../bloc/savings_state.dart';

class CreateSavingsGoalPage extends StatefulWidget {
  const CreateSavingsGoalPage({super.key});

  @override
  State<CreateSavingsGoalPage> createState() => _CreateSavingsGoalPageState();
}

class _CreateSavingsGoalPageState extends State<CreateSavingsGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _initialAmountController = TextEditingController();

  final DateTime _targetDate = DateTime.now().add(const Duration(days: 180));

  final List<Map<String, String>> _presets = [
    {'name': 'Emergency Fund', 'icon': 'shield'},
    {'name': 'Laptop', 'icon': 'laptop'},
    {'name': 'Phone', 'icon': 'phone'},
    {'name': 'Travel', 'icon': 'flight'},
    {'name': 'Education', 'icon': 'school'},
    {'name': 'Custom Goal', 'icon': 'savings'},
  ];

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final goal = SavingsGoal(
      id: '',
      title: _titleController.text.trim(),
      targetAmount: double.tryParse(_targetAmountController.text.trim()) ?? 0.0,
      currentAmount: double.tryParse(_initialAmountController.text.trim()) ?? 0.0,
      targetDate: _targetDate,
      iconName: 'savings',
      colorHex: '#10B981',
    );

    context.read<SavingsBloc>().add(CreateSavingsGoalEvent(goal));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    _initialAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(title: const Text('New Savings Goal')),
      body: BlocConsumer<SavingsBloc, SavingsState>(
        listener: (context, state) {
          if (state is SavingsOperationSuccessState || state is SavingsLoadedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Savings goal created!')),
            );
            context.pop(true);
          } else if (state is SavingsFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SavingsLoadingState;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Goal Preset Suggestions',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _presets.map((p) {
                      return ActionChip(
                        label: Text(p['name']!),
                        onPressed: () {
                          if (p['name'] != 'Custom Goal') {
                            _titleController.text = p['name']!;
                          } else {
                            _titleController.clear();
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Goal Title (e.g. Emergency Fund)', border: OutlineInputBorder()),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter goal title' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _targetAmountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Target Goal Amount (₹)', border: OutlineInputBorder(), prefixText: '₹ '),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter target amount' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _initialAmountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Initial Savings Deposit (Optional)', border: OutlineInputBorder(), prefixText: '₹ '),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _onSave,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.savings_rounded),
                      label: Text(
                        isLoading ? 'Creating...' : 'Create Goal',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
