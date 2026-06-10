enum AlertBannerActionType { snooze, acknowledge, dismiss, stop, openDetail }

class AlertBannerAction {
  final AlertBannerActionType type;
  final String label;
  final bool enabled;

  const AlertBannerAction({
    required this.type,
    required this.label,
    this.enabled = true,
  });
}
