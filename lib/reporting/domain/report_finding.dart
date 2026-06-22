class ReportFinding {
  final String title;
  final String body;
  final String tone;

  const ReportFinding({
    required this.title,
    required this.body,
    this.tone = 'neutral',
  });
}
