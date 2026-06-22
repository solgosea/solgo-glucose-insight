abstract interface class StatusProbeStrategy<T> {
  Future<T> probe();
}
