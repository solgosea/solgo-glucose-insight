import '../../domain/status_direction.dart';
import 'status_text_renderer.dart';

class StatusDirectionTextBuilder {
  final StatusTextRenderer renderer;

  const StatusDirectionTextBuilder({
    this.renderer = const StatusTextRenderer(),
  });

  List<StatusDirection> cgmDefaults() => [
        _direction('status.cgm.direction.session_source.v1', const {}),
        _direction(
          'status.cgm.direction.recent_readings.v1',
          const {'hours': 24},
        ),
      ];

  List<StatusDirection> nightscoutDefaults() => [
        _direction('status.nightscout.direction.measured_here.v1', const {}),
        _direction('status.nightscout.direction.device_context.v1', const {}),
      ];

  StatusDirection _direction(String key, Map<String, Object?> facts) {
    final text = renderer.render(key, facts);
    return StatusDirection(
      title: text.title ?? text.body,
      body: text.body,
      linkLabel: text.footer,
    );
  }
}
