class TemplateRenderer {
  const TemplateRenderer();

  String render(String template, Map<String, Object?> values) {
    var output = template;
    for (final entry in values.entries) {
      output = output.replaceAll('{${entry.key}}', _format(entry.value));
    }
    return output;
  }

  String _format(Object? value) {
    if (value == null) return '--';
    if (value is double) return value.toStringAsFixed(1);
    return value.toString();
  }
}
