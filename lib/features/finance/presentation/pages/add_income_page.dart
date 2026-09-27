import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/income.dart';
import '../bloc/income_bloc.dart';
import '../bloc/income_event.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedSourceCategory = 'SALARY';
  bool _isRecurring = false;

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final income = Income(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0.0,
      sourceCategory: _selectedSourceCategory,
      date: DateTime.now(),
      note: _noteController.text.trim(),
      isRecurring: _isRecurring,
    );

    context.read<IncomeBloc>().add(CreateIncomeEvent(income));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Income record saved!')),
    );
    context.pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Income')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title / Source Description', border: OutlineInputBorder()),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder(), prefixText: '₹ '),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter amount' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSourceCategory,
                decoration: const InputDecoration(labelText: 'Income Source Category', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'SALARY', child: Text('Salary')),
                  DropdownMenuItem(value: 'FREELANCE', child: Text('Freelance')),
                  DropdownMenuItem(value: 'ALLOWANCE', child: Text('Allowance')),
                  DropdownMenuItem(value: 'BUSINESS', child: Text('Business')),
                  DropdownMenuItem(value: 'INTEREST', child: Text('Interest & Investment')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                ],
                onChanged: (val) => setState(() => _selectedSourceCategory = val!),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Recurring Income'),
                subtitle: const Text('Repeats every month'),
                value: _isRecurring,
                onChanged: (val) => setState(() => _isRecurring = val),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Notes (Optional)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _onSave,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add Income', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
