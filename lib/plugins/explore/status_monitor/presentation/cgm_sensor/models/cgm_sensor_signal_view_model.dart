import '../../../domain/status_level.dart';
import 'cgm_sensor_signal_kind.dart';

class CgmSensorSignalViewModel {
  final CgmSensorSignalKind kind;
  final String title;
  final String valueLabel;
  final String detailLabel;
  final String sourceLabel;
  final StatusLevel level;
  final bool available;
  final double progress;
  final List<double> eventPositions;

  const CgmSensorSignalViewModel({
    required this.kind,
    required this.title,
    required this.valueLabel,
    required this.detailLabel,
    required this.sourceLabel,
    required this.level,
    required this.available,
    required this.progress,
    this.eventPositions = const [],
  });
}
