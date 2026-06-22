import 'report_section_type.dart';

class ReportSection {
  final String id;
  final String title;
  final ReportSectionType type;
  final String rendererKey;
  final int schemaVersion;
  final Object? payload;
  final bool enabledByDefault;

  const ReportSection({
    required this.id,
    required this.title,
    required this.type,
    required this.rendererKey,
    this.schemaVersion = 1,
    this.payload,
    this.enabledByDefault = true,
  });
}
