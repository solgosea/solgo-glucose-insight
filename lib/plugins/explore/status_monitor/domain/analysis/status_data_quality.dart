enum StatusDataQuality {
  normal,
  insufficientData,
  futureTimestamp,
  unavailable,
}

extension StatusDataQualityLabel on StatusDataQuality {
  String get label {
    return switch (this) {
      StatusDataQuality.normal => 'Normal',
      StatusDataQuality.insufficientData => 'Insufficient data',
      StatusDataQuality.futureTimestamp => 'Future timestamp',
      StatusDataQuality.unavailable => 'Unavailable',
    };
  }
}
