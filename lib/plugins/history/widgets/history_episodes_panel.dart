import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';
import '../application/i18n/history_l10n.dart';
import '../models/history_view_model.dart';
import 'history_episode_filter_chips.dart';
import 'history_episode_row.dart';

class HistoryEpisodesPanel extends StatefulWidget {
  final List<HistoryEpisodeCalloutViewModel> episodes;
  final ValueChanged<String> onRouteSelected;

  const HistoryEpisodesPanel({
    super.key,
    required this.episodes,
    required this.onRouteSelected,
  });

  @override
  State<HistoryEpisodesPanel> createState() => _HistoryEpisodesPanelState();
}

class _HistoryEpisodesPanelState extends State<HistoryEpisodesPanel> {
  static const _initialVisibleCount = 3;

  HistoryEpisodeFilter _filter = HistoryEpisodeFilter.all;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.episodes.isEmpty) return const SizedBox.shrink();

    final l10n = context.historyL10n;
    final filtered = _filteredEpisodes();
    final visible = _expanded || filtered.length <= _initialVisibleCount
        ? filtered
        : filtered.take(_initialVisibleCount).toList();
    final canToggle = filtered.length > _initialVisibleCount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.episodesPanelTitle,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: AppColors.textDim,
            ),
          ),
          const SizedBox(height: 9),
          HistoryEpisodeFilterChips(
            selected: _filter,
            allCount: widget.episodes.length,
            highCount: _countKind('high'),
            lowCount: _countKind('low'),
            allLabel: l10n.episodesFilterAll,
            highsLabel: l10n.episodesFilterHighs,
            lowsLabel: l10n.episodesFilterLows,
            onSelected: (filter) => setState(() {
              _filter = filter;
              _expanded = false;
            }),
          ),
          const SizedBox(height: 9),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            child: Column(
              key: ValueKey('${_filter.name}-$_expanded-${visible.length}'),
              children: [
                for (var i = 0; i < visible.length; i++) ...[
                  HistoryEpisodeRow(
                    episode: visible[i],
                    onTap: () => widget.onRouteSelected(visible[i].route),
                  ),
                  if (i != visible.length - 1) const SizedBox(height: 6),
                ],
              ],
            ),
          ),
          if (canToggle) ...[
            const SizedBox(height: 8),
            _ShowAllButton(
              label: _expanded
                  ? l10n.episodesShowLess
                  : l10n.episodesShowAll(filtered.length),
              onTap: () => setState(() => _expanded = !_expanded),
            ),
          ],
        ],
      ),
    );
  }

  List<HistoryEpisodeCalloutViewModel> _filteredEpisodes() {
    return switch (_filter) {
      HistoryEpisodeFilter.all => widget.episodes,
      HistoryEpisodeFilter.high =>
        widget.episodes.where((episode) => episode.kind == 'high').toList(),
      HistoryEpisodeFilter.low =>
        widget.episodes.where((episode) => episode.kind == 'low').toList(),
    };
  }

  int _countKind(String kind) =>
      widget.episodes.where((episode) => episode.kind == kind).length;
}

class _ShowAllButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ShowAllButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.borderMid,
              style: BorderStyle.solid,
            ),
            color: Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: AppColors.textSoft,
            ),
          ),
        ),
      ),
    );
  }
}
