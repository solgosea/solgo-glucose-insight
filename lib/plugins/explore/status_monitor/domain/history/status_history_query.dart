import 'status_history_scope.dart';
import 'status_history_window.dart';

class StatusHistoryQuery {
  final StatusHistoryScope scope;
  final StatusHistoryWindow window;

  const StatusHistoryQuery({
    required this.scope,
    required this.window,
  });
}
