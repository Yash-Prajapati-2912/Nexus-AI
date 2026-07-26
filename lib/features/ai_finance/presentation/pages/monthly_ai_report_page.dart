import 'package:flutter/material.dart';
import '../widgets/markdown_viewer.dart';

class MonthlyAIReportPage extends StatelessWidget {
  const MonthlyAIReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    const reportMarkdown = '''
# Monthly AI Financial Executive Report
## Month: July 2026

- **Total Earned**: \$3,291.25
- **Total Spent**: \$840.50
- **Net Monthly Savings**: \$2,450.75
- **Savings Rate**: 74.5%

## AI Key Highlights
- **Top Expense Category**: Education (\$500.00)
- **Spending Discipline**: Excellent adherence to monthly budget limits.
- **Goal Impact**: Advanced emergency fund target date by 14 days.
''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly AI Report'),
        actions: [
          IconButton(icon: const Icon(Icons.share_rounded), onPressed: () {}),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: MarkdownViewer(content: reportMarkdown),
      ),
    );
  }
}
