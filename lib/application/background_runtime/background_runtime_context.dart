import '../../domain/entities/app_settings.dart';

class BackgroundRuntimeContext {
  final AppSettings settings;
  final DateTime evaluatedAt;

  const BackgroundRuntimeContext({
    required this.settings,
    required this.evaluatedAt,
  });
}
