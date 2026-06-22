class StatusCgmContextLoader {
  const StatusCgmContextLoader();

  String sensorContextLabel(Map<String, dynamic>? sensorContext) {
    if (sensorContext == null || sensorContext.isEmpty) {
      return 'Session context is not exposed by this source.';
    }
    final age = sensorContext['sensorAge'] ?? sensorContext['age'];
    final remaining =
        sensorContext['remaining'] ?? sensorContext['daysRemaining'];
    if (remaining != null) return 'Session remaining: $remaining';
    if (age != null) return 'Sensor age: $age';
    return 'Sensor context is available.';
  }
}
