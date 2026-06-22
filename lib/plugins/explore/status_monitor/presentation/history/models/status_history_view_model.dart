import 'status_component_history_view_model.dart';

class StatusHistoryViewModel {
  final String title;
  final String subtitle;
  final List<StatusComponentHistoryViewModel> components;

  const StatusHistoryViewModel({
    required this.title,
    required this.subtitle,
    required this.components,
  });
}
