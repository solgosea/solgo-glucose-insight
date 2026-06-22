class StatusDirection {
  final String title;
  final String body;
  final String? linkLabel;
  final String? linkUrl;

  const StatusDirection({
    required this.title,
    required this.body,
    this.linkLabel,
    this.linkUrl,
  });

  Map<String, Object?> toJson() => {
        'title': title,
        'body': body,
        'linkLabel': linkLabel,
        'linkUrl': linkUrl,
      };
}
