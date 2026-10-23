import 'app.dart';
import 'bootstrap.dart';
import 'config/env/prod_env.dart';

void main() {
  bootstrap(ProdEnv(), () => const NexusApp());
}
