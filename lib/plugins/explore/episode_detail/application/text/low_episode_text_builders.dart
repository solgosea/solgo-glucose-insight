import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../../domain/episode_data_confidence.dart';
import '../../domain/low_episode_driver_type.dart';
import '../../domain/low_episode_recovery_quality.dart';
import '../../domain/low_episode_repeat_pattern.dart';
import '../../domain/low_episode_review_priority.dart';
import '../../domain/text/episode_detail_text_slot.dart';
import '../../domain/text/episode_detail_text_type.dart';
import 'episode_detail_text_renderer.dart';

class LowEpisodeSummaryTextBuilder {
  final EpisodeDetailTextRenderer renderer;

  const LowEpisodeSummaryTextBuilder({
    this.renderer = const EpisodeDetailTextRenderer(),
  });

  String title(
    LowEpisodeReviewPriority priority,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.lowSummaryTitle,
      type: _priorityType(priority),
      facts: facts,
      context: context,
    );
  }

  String subtitle(
    LowEpisodeReviewPriority priority,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.lowSummarySubtitle,
      type: _priorityType(priority),
      facts: facts,
      context: context,
    );
  }
}

class LowEpisodeBurdenTextBuilder {
  final EpisodeDetailTextRenderer renderer;

  const LowEpisodeBurdenTextBuilder({
    this.renderer = const EpisodeDetailTextRenderer(),
  });

  String note(
    LowEpisodeReviewPriority priority,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.lowBurdenNote,
      type: _priorityType(priority),
      facts: facts,
      context: context,
    );
  }
}

class LowEpisodeDriverTextBuilder {
  final EpisodeDetailTextRenderer renderer;

  const LowEpisodeDriverTextBuilder({
    this.renderer = const EpisodeDetailTextRenderer(),
  });

  String title(
    LowEpisodeDriverType type,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.lowDriverTitle,
      type: _driverType(type),
      facts: facts,
      context: context,
    );
  }

  String body(
    LowEpisodeDriverType type,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.lowDriverBody,
      type: _driverType(type),
      facts: facts,
      context: context,
    );
  }
}

class LowEpisodeRecoveryTextBuilder {
  final EpisodeDetailTextRenderer renderer;

  const LowEpisodeRecoveryTextBuilder({
    this.renderer = const EpisodeDetailTextRenderer(),
  });

  String note(
    LowEpisodeRecoveryQuality quality,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.lowRecoveryNote,
      type: _recoveryType(quality),
      facts: facts,
      context: context,
    );
  }
}

class LowEpisodeContextTextBuilder {
  final EpisodeDetailTextRenderer renderer;

  const LowEpisodeContextTextBuilder({
    this.renderer = const EpisodeDetailTextRenderer(),
  });

  String note(
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.lowContextNote,
      type: EpisodeDetailTextType.lowPriorityNotable,
      facts: facts,
      context: context,
    );
  }
}

class LowEpisodeRepeatTextBuilder {
  final EpisodeDetailTextRenderer renderer;

  const LowEpisodeRepeatTextBuilder({
    this.renderer = const EpisodeDetailTextRenderer(),
  });

  String title(
    LowEpisodeRepeatPatternType type,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.lowRepeatTitle,
      type: _repeatType(type),
      facts: facts,
      context: context,
    );
  }

  String body(
    LowEpisodeRepeatPatternType type,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.lowRepeatBody,
      type: _repeatType(type),
      facts: facts,
      context: context,
    );
  }

  String hint(
    LowEpisodeRepeatPatternType type,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.lowRepeatHint,
      type: EpisodeDetailTextType.lowRepeatNone,
      facts: facts,
      context: context,
    );
  }

  String takeaway(
    LowEpisodeRepeatPatternType type,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.lowRepeatTakeaway,
      type: _repeatType(type),
      facts: facts,
      context: context,
    );
  }
}

class LowEpisodeReliabilityTextBuilder {
  final EpisodeDetailTextRenderer renderer;

  const LowEpisodeReliabilityTextBuilder({
    this.renderer = const EpisodeDetailTextRenderer(),
  });

  String note(
    EpisodeDataConfidence confidence,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: EpisodeDetailTextSlot.lowReliabilityNote,
      type: _reliabilityType(confidence),
      facts: facts,
      context: context,
    );
  }
}

String _priorityType(LowEpisodeReviewPriority priority) {
  switch (priority) {
    case LowEpisodeReviewPriority.info:
      return EpisodeDetailTextType.lowPriorityInfo;
    case LowEpisodeReviewPriority.notable:
      return EpisodeDetailTextType.lowPriorityNotable;
    case LowEpisodeReviewPriority.important:
      return EpisodeDetailTextType.lowPriorityImportant;
  }
}

String _driverType(LowEpisodeDriverType type) {
  switch (type) {
    case LowEpisodeDriverType.nadir:
      return EpisodeDetailTextType.lowDriverNadir;
    case LowEpisodeDriverType.duration:
      return EpisodeDetailTextType.lowDriverDuration;
    case LowEpisodeDriverType.fastDescent:
      return EpisodeDetailTextType.lowDriverFastDescent;
    case LowEpisodeDriverType.slowRecovery:
      return EpisodeDetailTextType.lowDriverSlowRecovery;
    case LowEpisodeDriverType.nocturnalTiming:
      return EpisodeDetailTextType.lowDriverNocturnal;
    case LowEpisodeDriverType.repeatPattern:
      return EpisodeDetailTextType.lowDriverRepeat;
    case LowEpisodeDriverType.mixed:
      return EpisodeDetailTextType.lowDriverMixed;
  }
}

String _recoveryType(LowEpisodeRecoveryQuality quality) {
  switch (quality) {
    case LowEpisodeRecoveryQuality.quick:
      return EpisodeDetailTextType.lowRecoveryQuick;
    case LowEpisodeRecoveryQuality.gradual:
      return EpisodeDetailTextType.lowRecoveryGradual;
    case LowEpisodeRecoveryQuality.slow:
      return EpisodeDetailTextType.lowRecoverySlow;
    case LowEpisodeRecoveryQuality.unknown:
      return EpisodeDetailTextType.lowRecoveryUnknown;
  }
}

String _repeatType(LowEpisodeRepeatPatternType type) {
  switch (type) {
    case LowEpisodeRepeatPatternType.nocturnal:
      return EpisodeDetailTextType.lowRepeatNocturnal;
    case LowEpisodeRepeatPatternType.afternoon:
      return EpisodeDetailTextType.lowRepeatAfternoon;
    case LowEpisodeRepeatPatternType.sameTime:
      return EpisodeDetailTextType.lowRepeatSameTime;
    case LowEpisodeRepeatPatternType.fastDescent:
      return EpisodeDetailTextType.lowRepeatFastDescent;
    case LowEpisodeRepeatPatternType.none:
      return EpisodeDetailTextType.lowRepeatNone;
  }
}

String _reliabilityType(EpisodeDataConfidence confidence) {
  switch (confidence) {
    case EpisodeDataConfidence.high:
      return EpisodeDetailTextType.lowReliabilityHigh;
    case EpisodeDataConfidence.medium:
      return EpisodeDetailTextType.lowReliabilityMedium;
    case EpisodeDataConfidence.low:
      return EpisodeDetailTextType.lowReliabilityLow;
  }
}
