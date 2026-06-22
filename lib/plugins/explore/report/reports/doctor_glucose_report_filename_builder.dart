import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

import 'doctor_glucose_report_payloads.dart';
import 'doctor_glucose_report_section_keys.dart';

class DoctorGlucoseReportFilenameBuilder {
  const DoctorGlucoseReportFilenameBuilder();

  String build(ReportSnapshot snapshot) {
    final period = _periodLabel(snapshot);
    final stamp = _stamp(snapshot.generatedAt);
    return 'solgoinsight-glucose-report-$period-$stamp.pdf';
  }

  String _periodLabel(ReportSnapshot snapshot) {
    for (final section in snapshot.sections) {
      if (section.rendererKey != DoctorGlucoseReportSectionKeys.document) {
        continue;
      }
      final payload = section.payload;
      if (payload is DoctorGlucoseReportDocumentPayload) {
        return payload.viewModel.selectedPeriod.label;
      }
    }
    final days = snapshot.range.end.difference(snapshot.range.start).inDays + 1;
    return '${days}d';
  }

  String _stamp(DateTime time) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${time.year}${two(time.month)}${two(time.day)}-${two(time.hour)}${two(time.minute)}';
  }
}
