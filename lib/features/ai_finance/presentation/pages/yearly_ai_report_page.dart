import 'package:flutter/material.dart';
import '../widgets/markdown_viewer.dart';

class YearlyAIReportPage extends StatelessWidget {
  const YearlyAIReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    const reportMarkdown = '''
# Annual AI Financial Intelligence Report
## Year 2026 Overview

- **Total Annual Income**: \$38,400.00
- **Total Annual Expense**: \$9,800.00
- **Total Net Accumulated Savings**: \$28,600.00
- **Annual Wellness Score**: 92/100

## Strategic Takeaways
- Stable cash flow across all 4 quarters.
- Low impulse purchasing risk.
''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yearly AI Report'),
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
