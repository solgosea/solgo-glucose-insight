import '../../../domain/status_level.dart';
import 'xdrip_signal_kind.dart';

class XdripSignalViewModel {
  final XdripSignalKind kind;
  final String title;
  final String valueLabel;
  final String detailLabel;
  final String sourceLabel;
  final StatusLevel level;
  final bool available;
  final double progress;

  const XdripSignalViewModel({
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
