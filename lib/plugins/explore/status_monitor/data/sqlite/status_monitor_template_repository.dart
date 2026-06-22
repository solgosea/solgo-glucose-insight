import '../../domain/text/status_text_template.dart';

abstract class StatusMonitorTemplateRepository {
  Future<void> upsertAll(List<StatusTextTemplate> templates);
}
