import '../../domain/data_source/data_source_kind.dart';
import 'handlers/data_source_handler.dart';
import 'handlers/nightscout_data_source_handler.dart';
import 'handlers/xdrip_local_data_source_handler.dart';

class DataSourceRegistry {
  final Map<DataSourceKind, DataSourceHandler> _handlers;

  DataSourceRegistry({
    List<DataSourceHandler> handlers = const [
      XdripLocalDataSourceHandler(),
      NightscoutDataSourceHandler(),
    ],
  }) : _handlers = {for (final handler in handlers) handler.kind: handler};

  DataSourceHandler handlerFor(DataSourceKind kind) {
    final handler = _handlers[kind];
    if (handler == null) {
      throw StateError('No data source handler registered for $kind');
    }
    return handler;
  }
}
