class AlertBannerTimeFormatter {
  const AlertBannerTimeFormatter();

  String countdown(DateTime until, DateTime now) {
    final seconds = until.difference(now).inSeconds.clamp(0, 24 * 60 * 60);
    final minutes = seconds ~/ 60;
    final rest = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${rest.toString().padLeft(2, '0')}';
  }

  String relative(DateTime time, DateTime now) {
    final diff = now.difference(time);
    if (diff.inSeconds < 60) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
