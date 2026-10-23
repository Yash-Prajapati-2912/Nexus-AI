// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/app.dart';

void main() {
  testWidgets('App instantiation test', (WidgetTester tester) async {
    expect(const NexusApp(), isNotNull);
  });
}
