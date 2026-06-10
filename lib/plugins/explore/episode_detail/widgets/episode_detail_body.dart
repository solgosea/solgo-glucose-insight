import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/navigation/safe_navigation.dart';
import '../shared/episode_chart_card.dart';
import '../shared/episode_context_card.dart';
import '../shared/episode_disclaimer.dart';
import '../shared/episode_header.dart';
import '../shared/episode_hero_card.dart';
import '../shared/episode_pattern_card.dart';
import '../shared/episode_similar_card.dart';

import '../models/episode_detail_view_model.dart';
import '../models/episode_kind.dart';
import 'episode_empty_state.dart';
import 'episode_nocturnal_badge.dart';
import 'episode_severity_card.dart';

class EpisodeDetailBody extends StatelessWidget {
  final EpisodeDetailViewModel viewModel;

  const EpisodeDetailBody({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (!viewModel.hasEpisode) {
      return EpisodeEmptyState(viewModel: viewModel);
    }

    final hero = viewModel.hero!;
    final chart = viewModel.chart!;
    final pattern = viewModel.pattern!;
    final themeColor =
        viewModel.kind == EpisodeKind.high ? AppColors.rose : AppColors.blue;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EpisodeHeader(
                title: viewModel.title,
                subtitle: viewModel.subtitle,
                onBack: () => context.safePopOrHome(),
              ),
              EpisodeHeroCard(
                valueLabel: hero.valueLabel,
                valueText: hero.valueText,
                valueUnit: hero.valueUnit,
                valueColor: hero.valueColor,
                durationText: hero.durationText,
                durationRange: hero.durationRange,
                onsetRateLabel: hero.onsetRateLabel,
                onsetRateText: hero.onsetRateText,
                onsetRateColor: hero.onsetRateColor,
                recoveryRateText: hero.recoveryRateText,
                areaLabel: hero.areaLabel,
                areaText: hero.areaText,
                areaColor: hero.areaColor,
                heroBg: hero.heroBg,
                heroBorder: hero.heroBorder,
                trailingBadge:
                    hero.showNocturnalBadge
                        ? const EpisodeNocturnalBadge()
                        : null,
              ),
              EpisodeChartCard(
                readings: chart.readings,
                unit: chart.unit,
                lowThreshold: chart.lowThreshold,
                highThreshold: chart.highThreshold,
                onsetTime: chart.onsetTime,
                peakOrNadirTime: chart.peakOrNadirTime,
                recoveryTime: chart.recoveryTime,
                themeColor: chart.themeColor,
                episode: chart.episode,
              ),
              EpisodeContextCard(rows: viewModel.contextRows),
              EpisodePatternCard(
                bigStat: pattern.bigStat,
                description: pattern.description,
                statColor: pattern.statColor,
                indicators: pattern.indicators,
                activeDotColor: pattern.activeDotColor,
                patternText: pattern.patternText,
                caveat: pattern.caveat,
                extraNote: pattern.extraNote,
              ),
              if (viewModel.severity != null)
                EpisodeSeverityCard(viewModel: viewModel.severity!),
              EpisodeSimilarSectionHeader(text: viewModel.similarHeader),
              if (viewModel.similarCards.isEmpty)
                const _NoSimilarEpisodes()
              else
                for (final card in viewModel.similarCards)
                  EpisodeSimilarCard(themeColor: themeColor, data: card),
              EpisodeDisclaimer(text: viewModel.disclaimer),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoSimilarEpisodes extends StatelessWidget {
  const _NoSimilarEpisodes();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text(
        'No similar episodes were found in the current analysis window.',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: AppColors.textDim,
          height: 1.4,
        ),
      ),
    );
  }
}
