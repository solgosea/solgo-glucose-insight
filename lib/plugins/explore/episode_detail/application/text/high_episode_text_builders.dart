import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../../domain/episode_data_confidence.dart';
import '../../domain/high_episode_driver_type.dart';
import '../../domain/high_episode_repeat_pattern.dart';
import '../../domain/high_episode_review_priority.dart';
import '../../domain/text/episode_detail_text_slot.dart';
import '../../domain/text/episode_detail_text_type.dart';
import 'episode_detail_text_renderer.dart';

class HighEpisodeSummaryTextBuilder {
  final EpisodeDetailTextRenderer renderer;

  const HighEpisodeSummaryTextBuilder({
    this.renderer = const EpisodeDetailTextRenderer(),
  });

  String title(
    HighEpisodeReviewPriority priority,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.highSummaryTitle,
      type: _priorityType(priority),
      facts: facts,
      context: context,
    );
  }

  String subtitle(
    HighEpisodeReviewPriority priority,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.highSummarySubtitle,
      type: _priorityType(priority),
      facts: facts,
      context: context,
    );
  }
}

class HighEpisodeBurdenTextBuilder {
  final EpisodeDetailTextRenderer renderer;

  const HighEpisodeBurdenTextBuilder({
    this.renderer = const EpisodeDetailTextRenderer(),
  });

  String note(
    HighEpisodeReviewPriority priority,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.highBurdenNote,
      type: _priorityType(priority),
      facts: facts,
      context: context,
    );
  }
}

class HighEpisodeDriverTextBuilder {
  final EpisodeDetailTextRenderer renderer;

  const HighEpisodeDriverTextBuilder({
    this.renderer = const EpisodeDetailTextRenderer(),
  });

  String title(
    HighEpisodeDriverType type,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.highDriverTitle,
      type: _driverType(type),
      facts: facts,
      context: context,
    );
  }

  String body(
    HighEpisodeDriverType type,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.highDriverBody,
      type: _driverType(type),
      facts: facts,
      context: context,
    );
  }
}

class HighEpisodeContextTextBuilder {
  final EpisodeDetailTextRenderer renderer;

  const HighEpisodeContextTextBuilder({
    this.renderer = const EpisodeDetailTextRenderer(),
  });

  String note(
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.highContextNote,
      type: EpisodeDetailTextType.highPriorityNotable,
      facts: facts,
      context: context,
    );
  }
}

class HighEpisodeRepeatTextBuilder {
  final EpisodeDetailTextRenderer renderer;

  const HighEpisodeRepeatTextBuilder({
    this.renderer = const EpisodeDetailTextRenderer(),
  });

  String title(
    HighEpisodeRepeatPatternType type,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.highRepeatTitle,
      type: _repeatType(type),
      facts: facts,
      context: context,
    );
  }

  String body(
    HighEpisodeRepeatPatternType type,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.highRepeatBody,
      type: _repeatType(type),
      facts: facts,
      context: context,
    );
  }

  String hint(
    HighEpisodeRepeatPatternType type,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.highRepeatHint,
      type: EpisodeDetailTextType.highRepeatMorning,
      facts: facts,
      context: context,
    );
  }

  String takeaway(
    HighEpisodeRepeatPatternType type,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.highRepeatTakeaway,
      type: _repeatType(type),
      facts: facts,
      context: context,
    );
  }
}

class HighEpisodeReliabilityTextBuilder {
  final EpisodeDetailTextRenderer renderer;

  const HighEpisodeReliabilityTextBuilder({
    this.renderer = const EpisodeDetailTextRenderer(),
  });

  String note(
    EpisodeDataConfidence confidence,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.highReliabilityNote,
      type: _reliabilityType(confidence),
      facts: facts,
      context: context,
    );
  }
}

String _priorityType(HighEpisodeReviewPriority priority) {
  switch (priority) {
    case HighEpisodeReviewPriority.info:
      return EpisodeDetailTextType.highPriorityInfo;
    case HighEpisodeReviewPriority.notable:
      return EpisodeDetailTextType.highPriorityNotable;
    case HighEpisodeReviewPriority.important:
      return EpisodeDetailTextType.highPriorityImportant;
  }
}

String _driverType(HighEpisodeDriverType type) {
  switch (type) {
    case HighEpisodeDriverType.peak:
      return EpisodeDetailTextType.highDriverPeak;
    case HighEpisodeDriverType.duration:
      return EpisodeDetailTextType.highDriverDuration;
    case HighEpisodeDriverType.fastRise:
      return EpisodeDetailTextType.highDriverFastRise;
    case HighEpisodeDriverType.slowRecovery:
      return EpisodeDetailTextType.highDriverSlowRecovery;
    case HighEpisodeDriverType.repeatPattern:
      return EpisodeDetailTextType.highDriverRepeat;
    case HighEpisodeDriverType.mixed:
      return EpisodeDetailTextType.highDriverMixed;
  }
}

String _repeatType(HighEpisodeRepeatPatternType type) {
  switch (type) {
    case HighEpisodeRepeatPatternType.morning:
      return EpisodeDetailTextType.highRepeatMorning;
    case HighEpisodeRepeatPatternType.evening:
      return EpisodeDetailTextType.highRepeatEvening;
    case HighEpisodeRepeatPatternType.sameTime:
      return EpisodeDetailTextType.highRepeatSameTime;
    case HighEpisodeRepeatPatternType.none:
      return EpisodeDetailTextType.highRepeatNone;
  }
}

String _reliabilityType(EpisodeDataConfidence confidence) {
  switch (confidence) {
    case EpisodeDataConfidence.high:
      return EpisodeDetailTextType.highReliabilityHigh;
    case EpisodeDataConfidence.medium:
      return EpisodeDetailTextType.highReliabilityMedium;
    case EpisodeDataConfidence.low:
      return EpisodeDetailTextType.highReliabilityLow;
  }
}
