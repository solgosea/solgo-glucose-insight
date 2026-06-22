import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/xdrip/xdrip_score_label_mapper.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';

void main() {
  test('maps xDrip link scores to data-link labels', () {
    const mapper = XdripScoreLabelMapper();

    expect(mapper.labelFor(null), 'Limited data');
    expect(mapper.labelFor(90), 'Fresh data link');
    expect(mapper.labelFor(75), 'Mostly fresh');
    expect(mapper.labelFor(55), 'Delayed link');
    expect(mapper.labelFor(30), 'Weak data link');

    expect(mapper.levelFor(null), StatusLevel.unknown);
    expect(mapper.levelFor(90), StatusLevel.healthy);
    expect(mapper.levelFor(55), StatusLevel.watch);
    expect(mapper.levelFor(30), StatusLevel.issue);
  });
}
