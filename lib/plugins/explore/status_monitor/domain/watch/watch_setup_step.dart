class WatchSetupStep {
  final String index;
  final String title;
  final String body;
  final String? settingPath;

  const WatchSetupStep({
    required this.index,
    required this.title,
    required this.body,
    this.settingPath,
  });

  Map<String, Object?> toJson() => {
        'index': index,
        'title': title,
        'body': body,
        'settingPath': settingPath,
      };
}
