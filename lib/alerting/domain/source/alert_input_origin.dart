class AlertInputOrigin {
  static const im = AlertInputOrigin('im');
  static const localAnalysis = AlertInputOrigin('local_analysis');
  static const cloud = AlertInputOrigin('cloud');
  static const system = AlertInputOrigin('system');

  final String code;

  const AlertInputOrigin(this.code);

  @override
  bool operator ==(Object other) {
    return other is AlertInputOrigin && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;
}
