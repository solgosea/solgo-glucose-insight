class GlucoseSyncTargetSourceMetadata {
  final String? nightscoutUrl;
  final String? accessToken;

  const GlucoseSyncTargetSourceMetadata({
    this.nightscoutUrl,
    this.accessToken,
  });

  bool get hasNightscout =>
      nightscoutUrl != null && nightscoutUrl!.trim().isNotEmpty;
}
