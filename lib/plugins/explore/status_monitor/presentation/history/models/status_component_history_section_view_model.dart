import '../../../domain/history/status_component_history_load_state.dart';
import '../../../domain/status_component_kind.dart';
import '../../../domain/status_level.dart';
import 'status_component_history_view_model.dart';

class StatusComponentHistorySectionViewModel {
  final StatusComponentKind component;
  final String title;
  final StatusLevel currentLevel;
  final StatusComponentHistoryLoadState state;
  final StatusComponentHistoryViewModel? history;
  final String? errorMessage;

  const StatusComponentHistorySectionViewModel({
    required this.component,
    required this.title,
    required this.currentLevel,
    required this.state,
    this.history,
    this.errorMessage,
  });
}
