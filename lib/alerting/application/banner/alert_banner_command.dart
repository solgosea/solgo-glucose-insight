import '../../presentation/banner/alert_banner_action.dart';

class AlertBannerCommand {
  final String itemId;
  final AlertBannerActionType actionType;
  final DateTime createdAt;

  AlertBannerCommand({
    required this.itemId,
    required this.actionType,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
