import 'app.dart';
import 'bootstrap.dart';
import 'config/env/staging_env.dart';

void main() {
  bootstrap(StagingEnv(), () => const NexusApp());
}
