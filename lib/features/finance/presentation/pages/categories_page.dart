import 'package:flutter/material.dart';
import '../../domain/entities/finance_category.dart';
import '../widgets/category_chip.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  final List<FinanceCategory> _categories = const [
    FinanceCategory(id: 'c1', name: 'Food & Dining', iconName: 'food', colorHex: '#EF4444', type: 'EXPENSE'),
    FinanceCategory(id: 'c2', name: 'Education', iconName: 'school', colorHex: '#3B82F6', type: 'EXPENSE'),
    FinanceCategory(id: 'c3', name: 'Transportation', iconName: 'transit', colorHex: '#F59E0B', type: 'EXPENSE'),
    FinanceCategory(id: 'c4', name: 'Shopping', iconName: 'shopping', colorHex: '#EC4899', type: 'EXPENSE'),
    FinanceCategory(id: 'c5', name: 'Salary', iconName: 'salary', colorHex: '#10B981', type: 'INCOME'),
    FinanceCategory(id: 'c6', name: 'Scholarship', iconName: 'school', colorHex: '#8B5CF6', type: 'INCOME'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CategoryChip(label: cat.name, iconName: cat.iconName, colorHex: cat.colorHex),
              title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Type: ${cat.type}'),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
          );
        },
      ),
    );
  }
}
