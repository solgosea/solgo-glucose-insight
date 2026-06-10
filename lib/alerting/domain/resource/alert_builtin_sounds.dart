import 'alert_sound_ref.dart';

class AlertBuiltinSounds {
  static const steadyPing = AlertSoundRef.asset(
    uri: 'audio/alerts/steady_ping.wav',
    displayName: 'Steady ping',
  );

  static const urgentPulse = AlertSoundRef.asset(
    uri: 'audio/alerts/urgent_pulse.wav',
    displayName: 'Urgent pulse',
  );

  static const defaultSound = urgentPulse;

  static const gentleChime = AlertSoundRef.asset(
    uri: 'audio/alerts/gentle_chime.wav',
    displayName: 'Gentle chime',
  );

  static const softBell = AlertSoundRef.asset(
    uri: 'audio/alerts/soft_bell.wav',
    displayName: 'Soft bell',
  );

  static const all = [urgentPulse, steadyPing, gentleChime, softBell];

  const AlertBuiltinSounds._();
}
