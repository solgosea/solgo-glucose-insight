enum StatusWidgetTemplate {
  compact('compact', 'Compact', '2x2'),
  flow('flow', 'Flow Chain', '4x2'),
  issue('issue', 'Issue Focus', '4x2'),
  detailed('detailed', 'Detailed', '4x4');

  final String code;
  final String label;
  final String sizeLabel;

  const StatusWidgetTemplate(this.code, this.label, this.sizeLabel);

  static StatusWidgetTemplate fromCode(String? code) {
    return values.firstWhere(
      (template) => template.code == code,
      orElse: () => StatusWidgetTemplate.flow,
    );
  }
}
