enum AnalysisModuleCode {
  realtime,
  dayView,
  agp,
  period,
  heatmap,
  insights,
  highEpisode,
  lowEpisode,
}

extension AnalysisModuleCodeValue on AnalysisModuleCode {
  String get code => name;
}
