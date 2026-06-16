enum FloatingSurfaceSegmentKind {
  glucose('glucose'),
  status('status');

  final String code;

  const FloatingSurfaceSegmentKind(this.code);

  static FloatingSurfaceSegmentKind fromCode(String? code) {
    return FloatingSurfaceSegmentKind.values.firstWhere(
      (kind) => kind.code == code,
      orElse: () => FloatingSurfaceSegmentKind.status,
    );
  }
}
