enum AlertActuatorCommandType {
  playSound,
  vibrate,
  showNotification,
  stopEvent,
  stopTarget,
  stopAll;

  String get code => name;
}
