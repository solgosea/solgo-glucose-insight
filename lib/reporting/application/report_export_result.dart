class ReportExportResult {
  final bool success;
  final String? filename;
  final Object? error;

  const ReportExportResult._({
    required this.success,
    this.filename,
    this.error,
  });

  const ReportExportResult.success(String filename)
      : this._(success: true, filename: filename);

  const ReportExportResult.failure(Object error)
      : this._(success: false, error: error);
}
