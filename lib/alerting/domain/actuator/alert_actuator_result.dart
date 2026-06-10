class AlertActuatorResult {
  final bool success;
  final String message;
  final Map<String, Object?> details;

  const AlertActuatorResult({
    required this.success,
    required this.message,
    this.details = const {},
  });

  const AlertActuatorResult.success({
    this.message = 'Actuator command completed.',
    this.details = const {},
  }) : success = true;

  const AlertActuatorResult.failure({
    required this.message,
    this.details = const {},
  }) : success = false;
}
