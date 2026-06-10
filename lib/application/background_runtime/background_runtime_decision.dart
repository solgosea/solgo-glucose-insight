import 'background_runtime_reason.dart';

class BackgroundRuntimeDecision {
  final bool shouldRun;
  final Set<BackgroundRuntimeReason> reasons;
  final String message;

  const BackgroundRuntimeDecision({
    required this.shouldRun,
    required this.reasons,
    required this.message,
  });

  factory BackgroundRuntimeDecision.fromReasons(
    Set<BackgroundRuntimeReason> reasons,
  ) {
    if (reasons.isEmpty) {
      return const BackgroundRuntimeDecision(
        shouldRun: false,
        reasons: {},
        message: 'No background runtime strategy is active.',
      );
    }
    final labels = reasons.map((reason) => reason.label).join(', ');
    return BackgroundRuntimeDecision(
      shouldRun: true,
      reasons: Set.unmodifiable(reasons),
      message: 'Background runtime active: $labels.',
    );
  }
}
