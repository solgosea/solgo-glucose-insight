import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Explore omits retired wellness and labs slot remnants', () {
    final page =
        File('lib/plugins/explore/pages/explore_page.dart').readAsStringSync();
    final refreshService = File(
      'lib/plugins/explore/application/explore_entry_state_refresh_service.dart',
    ).readAsStringSync();

    expect(page, isNot(contains('ExploreSlotHost')));
    expect(page, isNot(contains('ExploreSlots.wellness')));
    expect(page, isNot(contains('sectionLabs')));
    expect(page, isNot(contains('glucose_music')));
    expect(refreshService, isNot(contains('ExploreSlots.wellness')));
  });
}
