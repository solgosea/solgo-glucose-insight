import 'package:flutter/foundation.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';

import '../../runtime/status_monitor_runtime.dart';
import 'status_dashboard_page_flow_phase.dart';
import 'status_dashboard_page_flow_state.dart';

class StatusDashboardPageFlowController extends ChangeNotifier {
  StatusDashboardPageFlowState _state =
      const StatusDashboardPageFlowState.idle();
  bool _disposed = false;

  StatusDashboardPageFlowState get state => _state;

  Future<void> start(PluginRuntimeManager runtimeManager) async {
    _emit(
      _state.copyWith(
        phase: StatusDashboardPageFlowPhase.resolvingServices,
        clearError: true,
      ),
    );
    try {
      _emit(
          _state.copyWith(phase: StatusDashboardPageFlowPhase.startingChecks));
      await runtimeManager.resume(StatusMonitorRuntime.id);
      _emit(_state.copyWith(phase: StatusDashboardPageFlowPhase.checking));
    } catch (error) {
      _emit(
        _state.copyWith(
          phase: StatusDashboardPageFlowPhase.failed,
          error: error,
        ),
      );
    }
  }

  void _emit(StatusDashboardPageFlowState next) {
    _state = next;
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _state = _state.copyWith(phase: StatusDashboardPageFlowPhase.disposed);
    super.dispose();
  }
}
