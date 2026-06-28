import 'juggluco_chain_focus.dart';

class JugglucoChainComparison {
  final String jugglucoAgeLabel;
  final String xdripAgeLabel;
  final String nightscoutAgeLabel;
  final JugglucoChainFocus focus;
  final String message;

  const JugglucoChainComparison({
    required this.jugglucoAgeLabel,
    required this.xdripAgeLabel,
    required this.nightscoutAgeLabel,
    required this.focus,
    required this.message,
  });

  Map<String, Object?> toJson() => {
        'jugglucoAgeLabel': jugglucoAgeLabel,
        'xdripAgeLabel': xdripAgeLabel,
        'nightscoutAgeLabel': nightscoutAgeLabel,
        'focus': focus.name,
        'message': message,
      };
}
