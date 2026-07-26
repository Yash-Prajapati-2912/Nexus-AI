import 'app.dart';
import 'bootstrap.dart';
import 'config/env/dev_env.dart';

void main() {
  bootstrap(DevEnv(), () => const NexusApp());
}
