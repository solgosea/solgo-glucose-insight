class JugglucoOptionalInspection {
  final bool webServerConfigured;
  final String stateLabel;
  final String message;

  const JugglucoOptionalInspection({
    required this.webServerConfigured,
    required this.stateLabel,
    required this.message,
  });

  Map<String, Object?> toJson() => {
        'webServerConfigured': webServerConfigured,
        'stateLabel': stateLabel,
        'message': message,
      };
}
