import 'app.dart';
import 'bootstrap.dart';
import 'config/env/qa_env.dart';

void main() {
  bootstrap(QAEnv(), () => const NexusApp());
}
