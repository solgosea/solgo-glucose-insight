class AlertQueueProcessingLock {
  bool _running = false;

  bool tryAcquire() {
    if (_running) return false;
    _running = true;
    return true;
  }

  void release() {
    _running = false;
  }
}
