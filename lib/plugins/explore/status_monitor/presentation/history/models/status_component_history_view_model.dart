import '../../../domain/status_component_kind.dart';
import '../../../domain/status_level.dart';
import 'status_history_cell_view_model.dart';

class StatusComponentHistoryViewModel {
  final StatusComponentKind component;
  final String title;
  final StatusLevel currentLevel;
  final double coverage;
  final List<StatusHistoryCellViewModel> dailyCells;
  final List<List<StatusHistoryCellViewModel>> hourlyRows;

  const StatusComponentHistoryViewModel({
    required this.component,
    required this.title,
    required this.currentLevel,
    required this.coverage,
    required this.dailyCells,
    required this.hourlyRows,
  });
}
