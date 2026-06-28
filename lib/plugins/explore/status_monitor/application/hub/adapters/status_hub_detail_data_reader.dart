class StatusHubDetailDataReader {
  const StatusHubDetailDataReader();

  Map<String, Object?> detail(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is Map<String, Object?>) return value;
    if (value is Map) return Map<String, Object?>.from(value);
    return const {};
  }

  List<Map<String, Object?>> list(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is! List) return const [];
    return value.whereType<Map>().map(Map<String, Object?>.from).toList();
  }

  String string(Map<String, Object?> json, String key, [String fallback = '']) {
    final value = json[key];
    if (value == null) return fallback;
    return value.toString();
  }

  bool boolean(Map<String, Object?> json, String key, [bool fallback = false]) {
    final value = json[key];
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return fallback;
  }

  int? integer(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
