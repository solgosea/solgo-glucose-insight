import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/insight/template_renderer.dart';

void main() {
  test('renders insight templates with numeric values', () {
    const renderer = TemplateRenderer();

    final text = renderer.render('TIR {tir}% and mean {mean} mmol/L', {
      'tir': 82,
      'mean': 6.42,
    });

    expect(text, 'TIR 82% and mean 6.4 mmol/L');
  });
}
