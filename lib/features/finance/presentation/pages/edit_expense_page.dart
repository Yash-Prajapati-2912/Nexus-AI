import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/expense.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';

class EditExpensePage extends StatefulWidget {
  final Expense? expense;

  const EditExpensePage({super.key, this.expense});

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  late String _selectedCategoryName;
  late String _selectedPaymentMethod;
  late bool _isRecurring;

  @override
  void initState() {
    super.initState();
    final exp = widget.expense;
    _titleController = TextEditingController(text: exp?.title ?? '');
    _amountController = TextEditingController(text: exp != null ? exp.amount.toString() : '');
    _noteController = TextEditingController(text: exp?.note ?? '');
    _selectedCategoryName = exp?.categoryName ?? 'Food & Dining';
    _selectedPaymentMethod = exp?.paymentMethod ?? 'CARD';
    _isRecurring = exp?.isRecurring ?? false;
  }

  void _onUpdate() {
    if (!_formKey.currentState!.validate()) return;

    final updated = (widget.expense ??
            Expense(
              id: 'exp-updated',
              title: '',
              amount: 0,
              categoryId: '',
              categoryName: '',
              categoryIcon: '',
              date: DateTime.now(),
            ))
        .copyWith(
      title: _titleController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0.0,
      categoryName: _selectedCategoryName,
      paymentMethod: _selectedPaymentMethod,
      isRecurring: _isRecurring,
      note: _noteController.text.trim(),
    );

    context.read<ExpenseBloc>().add(UpdateExpenseEvent(updated));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense updated successfully!')),
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
      appBar: AppBar(title: const Text('Edit Expense')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder()),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter amount' : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Recurring Expense'),
                value: _isRecurring,
                onChanged: (val) => setState(() => _isRecurring = val),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _onUpdate,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Update Expense', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
