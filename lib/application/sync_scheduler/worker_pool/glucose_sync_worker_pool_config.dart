class GlucoseSyncWorkerPoolConfig {
  final int globalConcurrency;
  final int perHostConcurrency;
  final int persistenceConcurrency;
  final int maxBatchSize;

  const GlucoseSyncWorkerPoolConfig({
    this.globalConcurrency = 4,
    this.perHostConcurrency = 1,
    this.persistenceConcurrency = 1,
    this.maxBatchSize = 32,
  });

  GlucoseSyncWorkerPoolConfig normalized() {
    return GlucoseSyncWorkerPoolConfig(
      globalConcurrency: globalConcurrency < 1 ? 1 : globalConcurrency,
      perHostConcurrency: perHostConcurrency < 1 ? 1 : perHostConcurrency,
      persistenceConcurrency:
          persistenceConcurrency < 1 ? 1 : persistenceConcurrency,
      maxBatchSize: maxBatchSize < 1 ? 1 : maxBatchSize,
    );
  }
}
