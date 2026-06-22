import '../../../domain/status_level.dart';
import 'nightscout_signal_kind.dart';

class NightscoutSignalViewModel {
  final NightscoutSignalKind kind;
  final String title;
  final String valueLabel;
  final String detailLabel;
  final String sourceLabel;
  final StatusLevel level;
  final bool available;
  final double progress;

  const NightscoutSignalViewModel({
    required this.kind,
    required this.title,
    required this.valueLabel,
    required this.detailLabel,
    required this.sourceLabel,
    required this.level,
    required this.available,
    required this.progress,
  });
}
