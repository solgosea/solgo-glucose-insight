import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/data_source/datasource_actions.dart';
import 'package:smart_xdrip/application/data_source/datasource_profile_section_services.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/rendering/plugin_render_context.dart';
import 'package:smart_xdrip/plugins/datasource/application/profile_section/datasource_profile_state_controller.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_refresh_reason.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_refresh_scope.dart';

import 'datasource_profile_card.dart';
import 'datasource_profile_view_model.dart';
import 'datasource_profile_view_model_mapper.dart';
import 'nightscout_setup_sheet.dart';

class DatasourceProfileSection extends StatefulWidget {
  final PluginRenderContext renderContext;

  const DatasourceProfileSection({
    super.key,
    required this.renderContext,
  });

  @override
  State<DatasourceProfileSection> createState() =>
      _DatasourceProfileSectionState();
}

class _DatasourceProfileSectionState extends State<DatasourceProfileSection> {
  final _mapper = const DatasourceProfileViewModelMapper();
  final _stateController = DatasourceProfileStateController();
  DatasourceProfileViewModel? _viewModel;
  bool _loading = false;
  DateTime? _lastCountdownRefreshAt;

  DatasourceProfileSectionServices get _services =>
      widget.renderContext.services.get<DatasourceProfileSectionServices>();

  DatasourceActions get _actions =>
      widget.renderContext.services.get<DatasourceActions>();

  @override
  void initState() {
    super.initState();
    _services.changeSignal.addListener(_handleHostChanged);
    _showInitialShell();
    unawaited(_refresh(DatasourceProfileRefreshReason.initial));
  }

  @override
  void dispose() {
    _services.changeSignal.removeListener(_handleHostChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = _viewModel;
    if (viewModel == null) {
      _showInitialShell();
    }
    return DatasourceProfileCard(
      viewModel: _viewModel!,
      onSourceAction: _handleSourceAction,
      onSourceStrategyAction: _handleSourceStrategyAction,
      onSourceSecondaryAction: _handleSourceSecondaryAction,
      onSyncCountdownDue: _handleSyncCountdownDue,
    );
  }

  void _handleHostChanged() {
    unawaited(_refresh(DatasourceProfileRefreshReason.hostChanged));
  }

  void _handleSyncCountdownDue() {
    final now = DateTime.now();
    final last = _lastCountdownRefreshAt;
    if (last != null && now.difference(last) < const Duration(seconds: 8)) {
      return;
    }
    _lastCountdownRefreshAt = now;
    unawaited(_refresh(DatasourceProfileRefreshReason.syncStatusChanged));
  }

  void _showInitialShell() {
    final state = _stateController.buildInitial(_services);
    _viewModel = _mapper.mapState(
      state: state,
      syncRuntimeStatus: _services.syncRuntimeStatus(),
    );
  }

  Future<void> _refresh(DatasourceProfileRefreshReason reason) async {
    if (_loading) return;
    _loading = true;
    try {
      final scope = _stateController.scopeFor(reason);
      var state = _stateController.startRefresh(reason: reason, scope: scope);
      if (mounted) {
        setState(() {
          _viewModel = _mapper.mapState(
            state: state,
            syncRuntimeStatus: _services.syncRuntimeStatus(),
          );
        });
      }
      state = scope == DatasourceProfileRefreshScope.syncStatusOnly
          ? await _stateController.loadSyncStatus(_services)
          : await _stateController.loadSnapshots(_services);
      if (!mounted) return;
      setState(
        () => _viewModel = _mapper.mapState(
          state: state,
          syncRuntimeStatus: _services.syncRuntimeStatus(),
        ),
      );
    } finally {
      _loading = false;
    }
  }

  Future<void> _handleSourceAction(
    DatasourceProfileSourceViewModel source,
  ) async {
    switch (source.action) {
      case DataSourceConnectionAction.connect:
        if (source.kind == DataSourceKind.xdripLocal) {
          await _connectXdripLocal();
        }
        break;
      case DataSourceConnectionAction.configure:
        if (source.kind == DataSourceKind.nightscout) {
          await _configureNightscout();
        }
        break;
      case DataSourceConnectionAction.sync:
        await _syncDataSource(source.kind);
        break;
      case DataSourceConnectionAction.disconnect:
        await _disconnectDataSource(source.kind);
        break;
      case DataSourceConnectionAction.use:
      case DataSourceConnectionAction.detect:
      case DataSourceConnectionAction.none:
        break;
    }
  }

  Future<void> _handleSourceStrategyAction(
    DatasourceProfileSourceViewModel source,
  ) async {
    switch (source.strategyAction) {
      case DataSourceSyncStrategyAction.enable:
        await _enableDataSourceSync(source.kind);
        break;
      case DataSourceSyncStrategyAction.disable:
        await _disableDataSourceSync(source.kind);
        break;
      case DataSourceSyncStrategyAction.syncNow:
      case DataSourceSyncStrategyAction.none:
        break;
    }
  }

  Future<void> _handleSourceSecondaryAction(
    DatasourceProfileSourceViewModel source,
  ) async {
    if (source.secondaryAction == DataSourceConnectionAction.configure &&
        source.kind == DataSourceKind.nightscout) {
      await _configureNightscout();
    }
  }

  Future<void> _connectXdripLocal() async {
    final result = await _actions.connectXdripLocal();
    await _reloadAndToast(result.message);
  }

  Future<void> _configureNightscout() async {
    final settings = _services.settingsProvider();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bgCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => NightscoutSetupSheet(
        initialUrl: settings.nightscoutBaseUrl ?? '',
        initialToken: settings.nightscoutToken ?? '',
        onTestAndConnect: _actions.connectNightscout,
      ),
    );
    _showInitialShell();
    await _refresh(DatasourceProfileRefreshReason.sourceActionCompleted);
  }

  Future<void> _syncDataSource(DataSourceKind kind) async {
    final message = (await _actions.syncDataSource(kind)).message;
    await _reloadAndToast(message);
  }

  Future<void> _enableDataSourceSync(DataSourceKind kind) async {
    final result = await _actions.enableDataSourceSync(kind);
    await _reloadAndToast(result.message);
  }

  Future<void> _disableDataSourceSync(DataSourceKind kind) async {
    final result = await _actions.disableDataSourceSync(kind);
    await _reloadAndToast(result.message);
  }

  Future<void> _disconnectDataSource(DataSourceKind kind) async {
    final result = await _actions.disconnectDataSource(kind);
    await _reloadAndToast(result.message);
  }

  Future<void> _reloadAndToast(String message) async {
    await _refresh(DatasourceProfileRefreshReason.sourceActionCompleted);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.bgCard2,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            color: AppColors.textSoft,
          ),
        ),
      ),
    );
  }
}
