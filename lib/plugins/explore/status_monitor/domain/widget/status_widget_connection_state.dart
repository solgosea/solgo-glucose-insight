enum StatusWidgetConnectionState {
  healthy('healthy'),
  watch('watch'),
  broken('broken'),
  unknown('unknown');

  final String code;

  const StatusWidgetConnectionState(this.code);
}
