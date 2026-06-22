class HighEpisodeReportFilenameBuilder {
  const HighEpisodeReportFilenameBuilder();

  String build(DateTime episodeTime) {
    final date =
        '${episodeTime.year.toString().padLeft(4, '0')}${episodeTime.month.toString().padLeft(2, '0')}${episodeTime.day.toString().padLeft(2, '0')}';
    final time =
        '${episodeTime.hour.toString().padLeft(2, '0')}${episodeTime.minute.toString().padLeft(2, '0')}';
    return 'solgoinsight-high-episode-report-$date-$time.pdf';
  }
}
