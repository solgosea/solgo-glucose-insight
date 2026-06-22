import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/scoring/status_score_label_mapper.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';

void main() {
  test('maps scores to user-facing labels and levels', () {
    const mapper = StatusScoreLabelMapper();

    expect(mapper.labelFor(null), 'Limited data');
    expect(mapper.labelFor(90), 'Stable checks');
    expect(mapper.labelFor(75), 'Worth watching');
    expect(mapper.labelFor(55), 'Needs a glance');
    expect(mapper.labelFor(30), 'Limited checks');

    expect(mapper.levelFor(null), StatusLevel.unknown);
    expect(mapper.levelFor(90), StatusLevel.healthy);
    expect(mapper.levelFor(55), StatusLevel.watch);
    expect(mapper.levelFor(30), StatusLevel.issue);
  });
}
