import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/nightscout/nightscout_score_label_mapper.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';

void main() {
  test('maps Nightscout cloud scores to cloud-link labels', () {
    const mapper = NightscoutScoreLabelMapper();

    expect(mapper.labelFor(null), 'Limited cloud data');
    expect(mapper.labelFor(91), 'Cloud link healthy');
    expect(mapper.labelFor(73), 'Cloud link watch');
    expect(mapper.labelFor(54), 'Cloud link delayed');
    expect(mapper.labelFor(40), 'Cloud link weak');

    expect(mapper.levelFor(null), StatusLevel.unknown);
    expect(mapper.levelFor(85), StatusLevel.healthy);
    expect(mapper.levelFor(50), StatusLevel.watch);
    expect(mapper.levelFor(49), StatusLevel.issue);
  });
}
