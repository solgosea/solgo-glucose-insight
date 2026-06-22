import '../../domain/status_report.dart';
import 'status_floating_service.dart';

class StatusFloatingRuntimeCoordinator {
  final StatusFloatingService service;

  const StatusFloatingRuntimeCoordinator({required this.service});

  Future<void> refresh(StatusReport report) {
    return service.update(report);
  }

  Future<void> stop() => service.stop();
}
