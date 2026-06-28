import 'datasource_profile_section_phase.dart';

class DatasourceProfileVisibilityPolicy {
  const DatasourceProfileVisibilityPolicy();

  bool shouldRenderCard(DatasourceProfileSectionPhase phase) {
    return switch (phase) {
      DatasourceProfileSectionPhase.ready ||
      DatasourceProfileSectionPhase.refreshing ||
      DatasourceProfileSectionPhase.errorRecoverable =>
        true,
      DatasourceProfileSectionPhase.initializing => false,
    };
  }
}
