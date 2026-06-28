class StatusProbeTimeoutPolicy {
  const StatusProbeTimeoutPolicy();

  Duration timeoutFor({required bool active, Duration? preferred}) {
    if (preferred != null) return preferred;
    return active ? const Duration(seconds: 5) : const Duration(seconds: 2);
  }
}
