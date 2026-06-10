import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime_capability.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime_lifecycle.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';

void main() {
  test('manager starts, resumes, pauses and stops plugin runtimes', () async {
    final manager = PluginRuntimeManager.create(
      now: () => DateTime(2026, 6, 6, 12),
    );
    addTearDown(manager.dispose);
    final runtime = _FakeRuntime();

    manager.register(runtime);
    expect(
      manager.store.snapshotFor(_FakeRuntime.id)?.lifecycle,
      PluginRuntimeLifecycle.idle,
    );

    await manager.resume(_FakeRuntime.id);
    expect(runtime.calls, ['start']);
    expect(
      manager.store.snapshotFor(_FakeRuntime.id)?.lifecycle,
      PluginRuntimeLifecycle.running,
    );

    await manager.resume(_FakeRuntime.id);
    expect(runtime.calls, ['start', 'resume']);

    await manager.pause(_FakeRuntime.id);
    expect(runtime.calls, ['start', 'resume', 'pause']);
    expect(
      manager.store.snapshotFor(_FakeRuntime.id)?.lifecycle,
      PluginRuntimeLifecycle.paused,
    );

    await manager.stop(_FakeRuntime.id);
    expect(runtime.calls, ['start', 'resume', 'pause', 'stop']);
    expect(
      manager.store.snapshotFor(_FakeRuntime.id)?.lifecycle,
      PluginRuntimeLifecycle.stopped,
    );
  });

  test('manager starts appStart runtimes during bootstrap', () async {
    final manager = PluginRuntimeManager.create();
    addTearDown(manager.dispose);
    final runtime = _FakeRuntime();

    manager.register(runtime, startPolicy: PluginRuntimeStartPolicy.appStart);
    await manager.startAppRuntimes();

    expect(runtime.calls, ['start']);
    expect(
      manager.store.snapshotFor(_FakeRuntime.id)?.lifecycle,
      PluginRuntimeLifecycle.running,
    );
  });
}

class _FakeRuntime implements PluginRuntime {
  static const id = PluginId('test.runtime');
  final List<String> calls = [];

  @override
  PluginRuntimeCapability get capability => PluginRuntimeCapability.runtime;

  @override
  PluginId get pluginId => id;

  @override
  Future<void> start(PluginRuntimeContext context) async {
    calls.add('start');
  }

  @override
  Future<void> resume(PluginRuntimeContext context) async {
    calls.add('resume');
  }

  @override
  Future<void> pause(PluginRuntimeContext context) async {
    calls.add('pause');
  }

  @override
  Future<void> stop(PluginRuntimeContext context) async {
    calls.add('stop');
  }
}
