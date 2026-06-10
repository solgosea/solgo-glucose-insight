import '../../domain/entities/app_settings.dart';
import 'background_runtime_context.dart';

class BackgroundRuntimeContextLoader {
  final DateTime Function() clock;

  const BackgroundRuntimeContextLoader({DateTime Function()? clock})
    : clock = clock ?? DateTime.now;

  Future<BackgroundRuntimeContext> load(AppSettings settings) async {
    return BackgroundRuntimeContext(settings: settings, evaluatedAt: clock());
  }
}
