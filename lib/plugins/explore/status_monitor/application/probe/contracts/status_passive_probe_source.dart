abstract interface class StatusPassiveProbeSource<T> {
  Future<T> latest();
}
