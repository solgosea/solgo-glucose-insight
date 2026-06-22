class StatusMonitorReportFilenameBuilder {
  const StatusMonitorReportFilenameBuilder();

  String build({required DateTime generatedAt}) {
    final y = generatedAt.year.toString().padLeft(4, '0');
    final m = generatedAt.month.toString().padLeft(2, '0');
    final d = generatedAt.day.toString().padLeft(2, '0');
    final hh = generatedAt.hour.toString().padLeft(2, '0');
    final mm = generatedAt.minute.toString().padLeft(2, '0');
    return 'solgoinsight-status-monitor-report-$y$m$d-$hh$mm.pdf';
  }
}
