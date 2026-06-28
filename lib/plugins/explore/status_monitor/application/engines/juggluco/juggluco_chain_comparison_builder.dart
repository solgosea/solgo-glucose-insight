import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/juggluco/juggluco_chain_comparison.dart';
import '../../../domain/juggluco/juggluco_chain_focus.dart';
import '../../../domain/juggluco/juggluco_path_state.dart';

class JugglucoChainComparisonBuilder {
  const JugglucoChainComparisonBuilder();

  JugglucoChainComparison build({
    required StatusAnalysisContext context,
    required JugglucoPathState state,
  }) {
    final jugglucoAge =
        context.evidence.jugglucoEvidence.latestAge(context.now);
    final xdripLatest =
        context.evidence.xdripLocalEvidence.readings.lastOrNull?.timestamp;
    final nightscoutLatest =
        context.evidence.nightscoutEvidence.readings.lastOrNull?.timestamp;
    final xdripAge =
        xdripLatest == null ? null : context.now.difference(xdripLatest).abs();
    final nightscoutAge = nightscoutLatest == null
        ? null
        : context.now.difference(nightscoutLatest).abs();

    final focus = _focus(state, xdripAge, nightscoutAge);
    return JugglucoChainComparison(
      jugglucoAgeLabel: _age(jugglucoAge),
      xdripAgeLabel: _age(xdripAge),
      nightscoutAgeLabel: _age(nightscoutAge),
      focus: focus,
      message: _message(focus),
    );
  }

  JugglucoChainFocus _focus(
    JugglucoPathState state,
    Duration? xdripAge,
    Duration? nightscoutAge,
  ) {
    if (state == JugglucoPathState.notConfigured) {
      return JugglucoChainFocus.setupRequired;
    }
    if (state == JugglucoPathState.waitingForFirstBroadcast) {
      return JugglucoChainFocus.setupRequired;
    }
    if (state == JugglucoPathState.directOnly) {
      return JugglucoChainFocus.jugglucoToXdrip;
    }
    if (state == JugglucoPathState.stale ||
        state == JugglucoPathState.unavailable) {
      return JugglucoChainFocus.sourceSide;
    }
    if (state == JugglucoPathState.fresh ||
        state == JugglucoPathState.delayed) {
      if (xdripAge != null && xdripAge.inMinutes > 20) {
        return JugglucoChainFocus.jugglucoToXdrip;
      }
      if (nightscoutAge != null && nightscoutAge.inMinutes > 20) {
        return JugglucoChainFocus.xdripToNightscout;
      }
      return JugglucoChainFocus.localPathFlowing;
    }
    return JugglucoChainFocus.unknown;
  }

  String _message(JugglucoChainFocus focus) {
    return switch (focus) {
      JugglucoChainFocus.localPathFlowing =>
        'Local Juggluco path is flowing. Continue comparing cloud freshness if Nightscout appears behind.',
      JugglucoChainFocus.jugglucoToXdrip =>
        'Juggluco direct broadcast is visible, but the xDrip-compatible path is not confirmed. Check Patched Libre or 640G/EverSense broadcast settings.',
      JugglucoChainFocus.xdripToNightscout =>
        'Local data looks fresh, but Nightscout is behind. Check upload settings, network, token, or Nightscout availability.',
      JugglucoChainFocus.sourceSide =>
        'The local Juggluco path is stale. Start by checking Juggluco, sensor connection, phone permissions, and battery restrictions.',
      JugglucoChainFocus.setupRequired =>
        'Solgo Insight is ready for Juggluco broadcasts. Wait for the first glucose reading before judging the local path.',
      JugglucoChainFocus.unknown =>
        'More local and cloud evidence is needed before selecting a likely focus.',
    };
  }

  String _age(Duration? age) {
    if (age == null) return 'Unknown';
    if (age.inMinutes < 1) return '${age.inSeconds}s';
    if (age.inHours < 1) return '${age.inMinutes}m';
    return '${age.inHours}h';
  }
}
