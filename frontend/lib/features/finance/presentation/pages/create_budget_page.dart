import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/budget.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';

class CreateBudgetPage extends StatefulWidget {
  const CreateBudgetPage({super.key});

  @override
  State<CreateBudgetPage> createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  final Map<String, TextEditingController> _categoryControllers = {
    'Food & Dining': TextEditingController(),
    'Transportation': TextEditingController(),
    'Education': TextEditingController(),
    'Shopping': TextEditingController(),
    'Entertainment': TextEditingController(),
    'Bills & Utilities': TextEditingController(),
    'Other': TextEditingController(),
    'Savings': TextEditingController(),
  };

  bool _showCategoryAllocations = false;

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    for (var controller in _categoryControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double get _totalBudget => double.tryParse(_amountController.text.trim()) ?? 0.0;

  double get _totalAllocated {
    double sum = 0.0;
    for (var controller in _categoryControllers.values) {
      sum += double.tryParse(controller.text.trim()) ?? 0.0;
    }
    return sum;
  }

  double get _unallocatedAmount => _totalBudget - _totalAllocated;
  bool get _isExceeded => _showCategoryAllocations && _totalAllocated > _totalBudget;

  bool _isSubmitting = false;

  void _onSave() {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;
    if (_isExceeded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category allocations exceed your monthly budget.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final startDate = DateTime(_selectedYear, _selectedMonth, 1);
    final endDate = DateTime(_selectedYear, _selectedMonth + 1, 0);

    final budget = Budget(
      id: '',
      name: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : '${_months[_selectedMonth - 1]} $_selectedYear Budget',
      totalLimit: _totalBudget,
      currentSpent: 0.0,
      period: 'MONTHLY',
      startDate: startDate,
      endDate: endDate,
    );

    context.read<BudgetBloc>().add(CreateBudgetEvent(budget));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saving monthly budget...')),
    );
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Monthly Budget', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period selection card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _selectedMonth,
                          decoration: const InputDecoration(
                            labelText: 'Month',
                            border: OutlineInputBorder(),
                          ),
                          items: List.generate(12, (i) {
                            return DropdownMenuItem(
                              value: i + 1,
                              child: Text(_months[i]),
                            );
                          }),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedMonth = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _selectedYear,
                          decoration: const InputDecoration(
                            labelText: 'Year',
                            border: OutlineInputBorder(),
                          ),
                          items: [2025, 2026, 2027, 2028, 2029, 2030].map((y) {
                            return DropdownMenuItem(
                              value: y,
                              child: Text(y.toString()),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedYear = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Total Budget Amount
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Total Monthly Budget (₹)',
                  hintText: 'e.g. 30000',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter budget amount';
                  final num = double.tryParse(val.trim());
                  if (num == null || num <= 0) return 'Enter a valid positive amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes / Goal Description (Optional)',
                  hintText: 'e.g. College + personal expenses',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Optional Category Breakdown Switch
              SwitchListTile(
                title: const Text('Add Optional Category Allocations', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Specify budget caps for Food, Transport, Education, etc.'),
                value: _showCategoryAllocations,
                onChanged: (val) => setState(() => _showCategoryAllocations = val),
              ),

              if (_showCategoryAllocations) ...[
                const SizedBox(height: 16),
                // Real-time Allocation Summary Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isExceeded
                        ? Colors.redAccent.withAlpha(25)
                        : theme.colorScheme.primaryContainer.withAlpha(50),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isExceeded ? Colors.redAccent : theme.colorScheme.primary.withAlpha(100),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Budget: ₹${_totalBudget.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Allocated: ₹${_totalAllocated.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_isExceeded)
                        Row(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Category allocations exceed your monthly budget by ₹${(_totalAllocated - _totalBudget).toStringAsFixed(0)}.',
                                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ],
                        )
                      else if (_unallocatedAmount > 0)
                        Text(
                          '₹${_unallocatedAmount.toStringAsFixed(0)} remains unallocated.',
                          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ..._categoryControllers.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: entry.value,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: '${entry.key} Cap (₹)',
                        prefixText: '₹ ',
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  );
                }),
              ],

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isExceeded ? null : _onSave,
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text(
                    'Save Monthly Budget',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
