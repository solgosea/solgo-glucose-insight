import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';

abstract class DataSourceSyncStrategy {
  DataSourceKind get kind;

  bool isConfigured(AppSettings settings);

  bool isEnabled(AppSettings settings);

  bool canSync(AppSettings settings) =>
      isConfigured(settings) && isEnabled(settings);

  IGlucoseSource buildSource(AppSettings settings);

  AppSettings enable(AppSettings settings);

  AppSettings disable(AppSettings settings);
}
