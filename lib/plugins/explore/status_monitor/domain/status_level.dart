enum StatusLevel {
  healthy,
  watch,
  issue,
  unknown;

  int get severity {
    return switch (this) {
      StatusLevel.healthy => 0,
      StatusLevel.watch => 1,
      StatusLevel.issue => 2,
      StatusLevel.unknown => -1,
    };
  }

  String get label {
    return switch (this) {
      StatusLevel.healthy => 'Healthy',
      StatusLevel.watch => 'Watch',
      StatusLevel.issue => 'Issue',
      StatusLevel.unknown => 'Unknown',
    };
  }
}
