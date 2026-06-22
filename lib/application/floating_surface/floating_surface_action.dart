class FloatingSurfaceAction {
  final String segmentId;
  final String action;
  final String? value;

  const FloatingSurfaceAction({
    required this.segmentId,
    required this.action,
    this.value,
  });

  factory FloatingSurfaceAction.fromMap(Map<dynamic, dynamic> map) {
    return FloatingSurfaceAction(
      segmentId: map['segmentId'] as String? ?? '',
      action: map['action'] as String? ?? '',
      value: map['value'] as String?,
    );
  }
}
