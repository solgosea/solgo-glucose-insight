import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_action.dart';

void main() {
  test('parses native floating surface action payload', () {
    final action = FloatingSurfaceAction.fromMap({
      'segmentId': 'glance',
      'action': 'set_size_preset',
      'value': 'large',
    });

    expect(action.segmentId, 'glance');
    expect(action.action, 'set_size_preset');
    expect(action.value, 'large');
  });
}
