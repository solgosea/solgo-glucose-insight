import 'package:flutter/foundation.dart';

import '../../../plugin_platform/placement/explore_plugin_resolver.dart';
import '../runtime/explore_entry_state_store.dart';
import '../runtime/explore_runtime_snapshot.dart';

class ExploreController extends ChangeNotifier {
  final ExploreEntryStateStore store;

  ExploreRuntimeSnapshot? _snapshot;
  bool _disposed = false;

  ExploreController({required this.store}) {
    _snapshot = store.snapshot;
    store.addListener(_handleStoreChanged);
  }

  List<ExplorePluginSection> get sections =>
      (_snapshot?.sections ?? const <ExplorePluginSection>[])
          .map(
            (section) => ExplorePluginSection(
              title: section.title,
              resolvedEntries: section.resolvedEntries,
            ),
          )
          .where((section) => section.resolvedEntries.isNotEmpty)
          .toList(growable: false);

  bool get loading => _snapshot == null;

  DateTime? get refreshedAt => _snapshot?.refreshedAt;

  String? get refreshReason => _snapshot?.reason;

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
