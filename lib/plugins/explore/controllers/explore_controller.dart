import 'package:flutter/foundation.dart';

import '../models/explore_plugin_entry_models.dart';
import '../runtime/explore_entry_state_store.dart';
import '../runtime/explore_runtime_snapshot.dart';

class ExploreController extends ChangeNotifier {
  final ExploreEntryStateStore store;

  ExploreRuntimeSnapshot? _snapshot;
  bool _disposed = false;

  ExploreController({
    required this.store,
  }) {
    _snapshot = store.snapshot;
    store.addListener(_handleStoreChanged);
  }

  List<ExplorePluginSection> get sections =>
      (_snapshot?.sections ?? const <ExplorePluginSection>[])
          .map(
            (section) => ExplorePluginSection(
              title: section.title,
              resolvedEntries: section.resolvedEntries
                  .where((entry) => !_isFeatured(entry))
                  .toList(growable: false),
            ),
          )
          .where((section) => section.resolvedEntries.isNotEmpty)
          .toList(growable: false);

  ResolvedExplorePluginEntry? get reportFeatured =>
      _featuredByRoute('/explore/report');

  bool get loading => _snapshot == null;

  DateTime? get refreshedAt => _snapshot?.refreshedAt;

  String? get refreshReason => _snapshot?.reason;

  bool _isFeatured(ResolvedExplorePluginEntry resolved) {
    return resolved.entry.route == '/explore/report';
  }

  ResolvedExplorePluginEntry? _featuredByRoute(String route) {
    final sections = _snapshot?.sections;
    if (sections == null) return null;
    for (final section in sections) {
      for (final resolved in section.resolvedEntries) {
        if (resolved.entry.route == route) return resolved;
      }
    }
    return null;
  }

  void _handleStoreChanged() {
    if (_disposed) return;
    _snapshot = store.snapshot;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    store.removeListener(_handleStoreChanged);
    super.dispose();
  }
}
