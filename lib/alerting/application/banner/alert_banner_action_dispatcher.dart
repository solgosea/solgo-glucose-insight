import '../../presentation/banner/alert_banner_action.dart';
import '../../presentation/banner/alert_banner_item.dart';
import 'alert_banner_command.dart';
import 'alert_banner_command_bus.dart';

class AlertBannerActionDispatcher {
  final AlertBannerCommandBus bus;

  const AlertBannerActionDispatcher({required this.bus});

  void dispatch(AlertBannerItem item, AlertBannerAction action) {
    if (!action.enabled) return;
    bus.publish(AlertBannerCommand(itemId: item.id, actionType: action.type));
  }
}
