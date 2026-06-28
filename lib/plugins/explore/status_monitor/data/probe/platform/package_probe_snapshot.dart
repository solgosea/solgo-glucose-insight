class PackageProbeSnapshot {
  final String packageName;
  final bool visible;
  final bool installed;
  final String? versionName;
  final int? versionCode;
  final DateTime checkedAt;
  final String? error;

  const PackageProbeSnapshot({
    required this.packageName,
    required this.visible,
    required this.installed,
    this.versionName,
    this.versionCode,
    required this.checkedAt,
    this.error,
  });

  bool get hasError => error != null && error!.isNotEmpty;

  factory PackageProbeSnapshot.fromMap(Map<Object?, Object?> map) {
    final checkedAtMs = map['checkedAtMs'];
    final versionCode = map['versionCode'];
    return PackageProbeSnapshot(
      packageName: map['packageName']?.toString() ?? '',
      visible: map['visible'] == true,
      installed: map['installed'] == true,
      versionName: map['versionName']?.toString(),
      versionCode: versionCode is int
          ? versionCode
          : int.tryParse(versionCode?.toString() ?? ''),
      checkedAt: DateTime.fromMillisecondsSinceEpoch(
        checkedAtMs is int
            ? checkedAtMs
            : int.tryParse(checkedAtMs?.toString() ?? '') ?? 0,
      ),
      error: map['error']?.toString(),
    );
  }

  factory PackageProbeSnapshot.unsupported(
    String packageName,
    Object error,
  ) {
    return PackageProbeSnapshot(
      packageName: packageName,
      visible: false,
      installed: false,
      checkedAt: DateTime.now(),
      error: error.toString(),
    );
  }
}
