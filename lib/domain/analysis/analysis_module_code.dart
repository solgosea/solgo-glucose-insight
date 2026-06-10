enum AnalysisModuleCode {
  realtime,
  dayView,
  agp,
  period,
  heatmap,
  insights,
  glucoseEvents,
  highEpisode,
  lowEpisode,
}

extension AnalysisModuleCodeValue on AnalysisModuleCode {
  String get code => name;
}
