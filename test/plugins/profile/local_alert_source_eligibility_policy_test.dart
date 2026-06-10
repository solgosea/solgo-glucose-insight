import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';
import 'package:smart_xdrip/plugins/profile/alert_source/local_alert_source_eligibility_policy.dart';

void main() {
  const policy = LocalAlertSourceEligibilityPolicy();

  test('self local alerts are disabled until a datasource is enabled', () {
    expect(
      policy.canEvaluate(
        subjectId: GlucoseSubject.selfId,
        settings: const AppSettings(),
      ),
      isFalse,
    );
  });

  test('self local alerts are enabled for xDrip Local or Nightscout', () {
    expect(
      policy.canEvaluate(
        subjectId: GlucoseSubject.selfId,
        settings: const AppSettings(xdripSyncEnabled: true),
      ),
      isTrue,
    );
    expect(
      policy.canEvaluate(
        subjectId: GlucoseSubject.selfId,
        settings: const AppSettings(nightscoutSyncEnabled: true),
      ),
      isTrue,
    );
  });

  test('non-self subjects are not evaluated by the profile datasource source',
      () {
    expect(
      policy.canEvaluate(
        subjectId: 'external:child-a',
        settings: const AppSettings(nightscoutSyncEnabled: true),
      ),
      isFalse,
    );
  });
}
