enum PluginReleaseStage { hidden, comingSoon, beta, stable, deprecated }

extension PluginReleaseStageX on PluginReleaseStage {
  bool get isVisible => this != PluginReleaseStage.hidden;

  bool get isEnabled =>
      this == PluginReleaseStage.beta || this == PluginReleaseStage.stable;
}
