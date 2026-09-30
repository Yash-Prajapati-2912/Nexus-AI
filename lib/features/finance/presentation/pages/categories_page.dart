import 'package:flutter/material.dart';
import '../../../../di/injection_container.dart';
import '../../domain/entities/finance_category.dart';
import '../../domain/repositories/i_finance_repository.dart';
import '../widgets/category_chip.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<FinanceCategory> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final repo = getIt<IFinanceRepository>();
    final result = await repo.getCategories();
    if (mounted) {
      result.fold(
        (_) => setState(() => _isLoading = false),
        (cats) => setState(() {
          _categories = cats;
          _isLoading = false;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
