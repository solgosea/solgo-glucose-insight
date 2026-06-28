import 'juggluco_path_state.dart';
import 'juggluco_broadcast_path.dart';

class JugglucoFreshnessBucket {
  final DateTime at;
  final JugglucoPathState state;
  final JugglucoBroadcastPath path;

  const JugglucoFreshnessBucket({
    required this.at,
    required this.state,
    this.path = JugglucoBroadcastPath.unknown,
  });

  Map<String, Object?> toJson() => {
        'at': at.millisecondsSinceEpoch,
        'state': state.name,
        'path': path.name,
      };
}
