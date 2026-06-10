import '../../domain/entities/app_settings.dart';

class DataSourceConnectionResult {
  final bool success;
  final String message;
  final AppSettings? nextSettings;

  const DataSourceConnectionResult({
    required this.success,
    required this.message,
    this.nextSettings,
  });

  const DataSourceConnectionResult.success({
    required String message,
    AppSettings? nextSettings,
  }) : this(success: true, message: message, nextSettings: nextSettings);

  const DataSourceConnectionResult.failure(String message)
    : this(success: false, message: message);
}
