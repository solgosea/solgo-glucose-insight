class StatusSourceCapabilities {
  final bool entries;
  final bool entryRangeQuery;
  final bool deviceStatus;
  final bool nightscoutStatus;
  final bool pebble;
  final bool uploadLatency;
  final bool uploaderBattery;
  final String modeLabel;

  const StatusSourceCapabilities({
    required this.entries,
    required this.entryRangeQuery,
    required this.deviceStatus,
    required this.nightscoutStatus,
    required this.pebble,
    required this.uploadLatency,
    required this.uploaderBattery,
    required this.modeLabel,
  });

  const StatusSourceCapabilities.none()
      : entries = false,
        entryRangeQuery = false,
        deviceStatus = false,
        nightscoutStatus = false,
        pebble = false,
        uploadLatency = false,
        uploaderBattery = false,
        modeLabel = 'No data source';

  const StatusSourceCapabilities.nightscout()
      : entries = true,
        entryRangeQuery = true,
        deviceStatus = true,
        nightscoutStatus = true,
        pebble = false,
        uploadLatency = true,
        uploaderBattery = true,
        modeLabel = 'Nightscout full mode';

  const StatusSourceCapabilities.xdripLocal()
      : entries = true,
        entryRangeQuery = false,
        deviceStatus = false,
        nightscoutStatus = false,
        pebble = true,
        uploadLatency = false,
        uploaderBattery = true,
        modeLabel = 'xDrip+ local mode';
}
