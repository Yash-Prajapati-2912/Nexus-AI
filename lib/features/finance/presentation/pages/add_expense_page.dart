import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/injection_container.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/finance_category.dart';
import '../../domain/repositories/i_finance_repository.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _receiptUrlController = TextEditingController();

  List<FinanceCategory> _categories = [];
  FinanceCategory? _selectedCategory;
  bool _isLoadingCategories = true;

  String _selectedPaymentMethod = 'DEBIT_CARD';
  bool _isRecurring = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories({String? selectCategoryId}) async {
    setState(() => _isLoadingCategories = true);
    final repo = getIt<IFinanceRepository>();
    final result = await repo.getCategories();
    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            _isLoadingCategories = false;
          });
        }
      },
      (categories) {
        if (mounted) {
          setState(() {
            _categories = categories;
            if (selectCategoryId != null) {
              _selectedCategory = categories.firstWhere(
                (c) => c.id == selectCategoryId,
                orElse: () => categories.isNotEmpty ? categories.first : _selectedCategory!,
              );
            } else if (categories.isNotEmpty && _selectedCategory == null) {
              _selectedCategory = categories.first;
            }
            _isLoadingCategories = false;
          });
        }
      },
    );
  }

  Future<void> _showCreateCategoryDialog() async {
    final nameCtrl = TextEditingController();
    final isCreated = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Create Custom Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                hintText: 'e.g. Lab Supplies, Tech Subscriptions',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              final repo = getIt<IFinanceRepository>();
              final newCat = FinanceCategory(
                id: '',
                name: name,
                iconName: 'tag',
                colorHex: '#6366F1',
                type: 'EXPENSE',
              );
              final res = await repo.createCategory(newCat);
              if (res.isLeft()) {
                final failure = res.getLeft().toNullable()!;
                if (dialogCtx.mounted) {
                  ScaffoldMessenger.of(dialogCtx).showSnackBar(
                    SnackBar(content: Text('Failed to create category: ${failure.message}')),
                  );
                }
              } else {
                final created = res.getRight().toNullable()!;
                if (dialogCtx.mounted) {
                  Navigator.of(dialogCtx).pop(true);
                }
                await _loadCategories(selectCategoryId: created.id);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (isCreated == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category created successfully!')),
      );
    }
  }

  bool _isSubmitting = false;

  void _onSave() {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or wait for a category to load.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final tagsText = _tagsController.text.trim();
    final tagsList = tagsText.isNotEmpty
        ? tagsText.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList()
        : <String>[];
    final receiptUrl = _receiptUrlController.text.trim();

    final expense = Expense(
      id: '',
      title: _titleController.text.trim(),
      amount: amount,
      categoryId: _selectedCategory!.id,
      categoryName: _selectedCategory!.name,
      categoryIcon: _selectedCategory!.iconName.isNotEmpty ? _selectedCategory!.iconName : 'tag',
      date: _selectedDate,
      note: _noteController.text.trim(),
      receiptUrl: receiptUrl.isNotEmpty ? receiptUrl : null,
      tags: tagsList,
      isRecurring: _isRecurring,
      paymentMethod: _selectedPaymentMethod,
    );

    context.read<ExpenseBloc>().add(CreateExpenseEvent(expense));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saving expense...')),
    );
    context.pop(true);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _tagsController.dispose();
    _receiptUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title / Description',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter amount';
                  if (double.tryParse(val.trim()) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_isLoadingCategories)
                const LinearProgressIndicator()
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<FinanceCategory>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: _categories
                            .map((c) => DropdownMenuItem<FinanceCategory>(
                                  value: c,
                                  child: Text(c.name),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedCategory = val),
                        validator: (val) => val == null ? 'Please select a category' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: _showCreateCategoryDialog,
                      icon: const Icon(Icons.add_rounded),
                      tooltip: 'Add Custom Category',
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'DEBIT_CARD', child: Text('Debit Card')),
                  DropdownMenuItem(value: 'CREDIT_CARD', child: Text('Credit Card')),
                  DropdownMenuItem(value: 'UPI', child: Text('UPI / Digital Wallet')),
                  DropdownMenuItem(value: 'CASH', child: Text('Cash')),
                  DropdownMenuItem(value: 'BANK_TRANSFER', child: Text('Bank Transfer')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                ],
                onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(4),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Expense Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today_rounded),
                  ),
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (Optional)',
                  hintText: 'academics, books, project',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label_outline_rounded),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _receiptUrlController,
                decoration: const InputDecoration(
                  labelText: 'Receipt Attachment URL (Optional)',
                  hintText: 'https://...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.receipt_long_rounded),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Recurring Expense'),
                subtitle: const Text('Repeats automatically every month'),
                value: _isRecurring,
                onChanged: (val) => setState(() => _isRecurring = val),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _onSave,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Save Expense', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
