class StatusTraceIdFactory {
  const StatusTraceIdFactory();

  String probe(String probeId, DateTime observedAt) {
    return 'probe:$probeId:${observedAt.millisecondsSinceEpoch}';
  }

  String derived(String prefix, String sourceId, DateTime? at) {
    return '$prefix:$sourceId:${at?.millisecondsSinceEpoch ?? 0}';
  }
}
