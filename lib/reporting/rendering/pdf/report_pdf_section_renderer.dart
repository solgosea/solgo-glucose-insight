import 'package:pdf/widgets.dart' as pw;

import '../../domain/report_section.dart';

abstract class ReportPdfSectionRenderer {
  String get rendererKey;

  pw.Widget build(ReportSection section);
}
