import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/data/repositories/glucose_repository_impl.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

import '../../_support/test_database.dart';

void main() {
  test(
    'repository does not seed mock data when no datasource is enabled',
    () async {
      final database = TestDatabase.create();
      addTearDown(database.close);
      final repository = GlucoseRepositoryImpl(db: database);
      addTearDown(repository.dispose);

      await repository.applySettings(const AppSettings());
      await repository.sync();

      expect(await repository.latest(), isNull);
      expect(await repository.lastDays(14), isEmpty);
      expect(await database.count(), 0);
      expect(await database.getSourceState('mock'), isNull);
    },
  );
}
