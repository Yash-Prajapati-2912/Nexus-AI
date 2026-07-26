import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/savings_goal.dart';
import '../bloc/savings_bloc.dart';
import '../bloc/savings_event.dart';

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

  DateTime _targetDate = DateTime.now().add(const Duration(days: 180));

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final goal = SavingsGoal(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      targetAmount: double.tryParse(_targetAmountController.text.trim()) ?? 0.0,
      currentAmount: double.tryParse(_initialAmountController.text.trim()) ?? 0.0,
      targetDate: _targetDate,
      iconName: 'savings',
      colorHex: '#10B981',
    );

    context.read<SavingsBloc>().add(CreateSavingsGoalEvent(goal));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Savings goal created!')),
    );
    context.pop();
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
    return Scaffold(
      appBar: AppBar(title: const Text('New Savings Goal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Goal Title (e.g. New Laptop)', border: OutlineInputBorder()),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter goal title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetAmountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Target Goal Amount (\$)', border: OutlineInputBorder(), prefixText: '\$ '),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter target amount' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _initialAmountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Initial Savings Deposit (Optional)', border: OutlineInputBorder(), prefixText: '\$ '),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _onSave,
                  icon: const Icon(Icons.savings_rounded),
                  label: const Text('Create Goal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
