import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../bloc/income_bloc.dart';
import '../bloc/income_event.dart';
import '../bloc/income_state.dart';
import '../widgets/finance_skeleton.dart';
import '../widgets/income_card.dart';

import '../../../../shared/widgets/base_scaffold.dart';

class IncomeListPage extends StatefulWidget {
  const IncomeListPage({super.key});

  @override
  State<IncomeListPage> createState() => _IncomeListPageState();
}

class _IncomeListPageState extends State<IncomeListPage> {
  @override
  void initState() {
    super.initState();
    context.read<IncomeBloc>().add(const LoadIncomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Income Stream'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push(RouteNames.financeAddIncome);
          if (context.mounted) context.read<IncomeBloc>().add(const LoadIncomeEvent());
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Income'),
      ),
      body: BlocBuilder<IncomeBloc, IncomeState>(
        builder: (context, state) {
          if (state is IncomeLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: FinanceSkeleton(height: 100),
            );
          }

          if (state is IncomeLoadedState) {
            if (state.incomes.isEmpty) {
              return const Center(child: Text('No income records added yet.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
              itemCount: state.incomes.length,
              itemBuilder: (context, index) {
                final item = state.incomes[index];
                return IncomeCard(
                  income: item,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Income details: ${item.title}')),
                    );
                  },
                );
              },
            );
          }

          return const Center(child: Text('Pull to load incomes.'));
        },
      ),
    );
  }
}
