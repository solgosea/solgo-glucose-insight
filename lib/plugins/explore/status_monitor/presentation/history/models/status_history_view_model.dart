import 'status_component_history_section_view_model.dart';

class StatusHistoryViewModel {
  final String title;
  final String subtitle;
  final List<StatusComponentHistorySectionViewModel> sections;
  final bool loading;

  StatusHistoryViewModel({
    required this.title,
    required this.subtitle,
    required this.sections,
    this.loading = false,
  });
}
