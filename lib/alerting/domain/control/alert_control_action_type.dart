enum AlertControlActionType {
  snooze,
  acknowledge,
  recover,
  disableRule,
  stop;

  String get code => name;
}
