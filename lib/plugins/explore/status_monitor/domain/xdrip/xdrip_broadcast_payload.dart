class XdripBroadcastPayload {
  final double? glucose;
  final String? unit;
  final String? slopeName;
  final double? slope;
  final String? sourceAction;

  const XdripBroadcastPayload({
    this.glucose,
    this.unit,
    this.slopeName,
    this.slope,
    this.sourceAction,
  });

  bool get valid => glucose != null;

  Map<String, Object?> toJson() => {
        'glucose': glucose,
        'unit': unit,
        'slopeName': slopeName,
        'slope': slope,
        'sourceAction': sourceAction,
      };
}
