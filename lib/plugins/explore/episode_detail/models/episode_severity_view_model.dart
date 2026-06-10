enum EpisodeSeverityLevel { mild, significant, severe }

class EpisodeSeverityRowViewModel {
  final EpisodeSeverityLevel level;
  final String label;
  final String range;
  final String description;
  final bool isCurrent;

  const EpisodeSeverityRowViewModel({
    required this.level,
    required this.label,
    required this.range,
    required this.description,
    required this.isCurrent,
  });
}

class EpisodeSeverityViewModel {
  final List<EpisodeSeverityRowViewModel> rows;
  final String footnote;

  const EpisodeSeverityViewModel({required this.rows, required this.footnote});
}
