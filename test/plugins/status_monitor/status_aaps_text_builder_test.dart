import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/text/status_aaps_text_builder.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/scoring/status_component_score.dart';

void main() {
  group('StatusAapsTextBuilder', () {
    test('renders hero takeaway states from templates', () {
      const builder = StatusAapsTextBuilder();

      expect(
        builder.takeaway(
          const StatusComponentScore(
            value: 0,
            label: 'Unknown',
            availableSignals: 0,
            totalSignals: 6,
            confidence: 0,
          ),
        ),
        contains('not visible'),
      );
      expect(
        builder.takeaway(
          const StatusComponentScore(
            value: 90,
            label: 'Healthy',
            availableSignals: 6,
            totalSignals: 6,
            confidence: 1,
          ),
        ),
        contains('visible and recent'),
      );
    });

    test('renders default direction and rule explanation from templates', () {
      const builder = StatusAapsTextBuilder();

      final direction = builder.defaultDirection();
      expect(direction.title, contains('Nightscout device status'));
      expect(direction.body, contains('does not evaluate'));

      final explanation = builder.ruleExplanation(
        'status.aaps.rule.sync_freshness.available.v1',
        const {'ageLabel': '4m'},
      );
      expect(explanation.summary, contains('4m'));
      expect(explanation.templateKey,
          'status.aaps.rule.sync_freshness.available.v1');
    });
  });
}
