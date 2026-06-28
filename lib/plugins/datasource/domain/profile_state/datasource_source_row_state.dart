import 'package:smart_xdrip/domain/data_source/data_source_connection_snapshot.dart';

import 'datasource_source_row_phase.dart';

class DatasourceSourceRowState {
  final DataSourceConnectionSnapshot snapshot;
  final DatasourceSourceRowPhase phase;

  const DatasourceSourceRowState({
    required this.snapshot,
    required this.phase,
  });
}
