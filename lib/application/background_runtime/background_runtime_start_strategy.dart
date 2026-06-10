import 'background_runtime_context.dart';
import 'background_runtime_reason.dart';

abstract class BackgroundRuntimeStartStrategy {
  BackgroundRuntimeReason get reason;

  Future<bool> shouldStart(BackgroundRuntimeContext context);
}
