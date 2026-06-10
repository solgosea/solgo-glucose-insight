import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/application/data_source/data_source_connection_result.dart';
import 'package:smart_xdrip/application/nightscout/nightscout_url_normalizer.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';

import '../application/profile_data_source_actions.dart';
import '../application/profile_host_services.dart';
import '../application/profile_settings_actions.dart';
import '../controllers/profile_controller.dart';
import '../models/profile_view_model.dart';
import '../runtime/profile_plugin_runtime.dart';
import '../runtime/profile_runtime_cache.dart';
import '../target_range/target_range_ruler_sheet.dart';
import '../target_range/target_range_value_policy.dart';
import '../widgets/profile_body.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted && _isUninitialized) {
      _isUninitialized = false;
      final services = context.read<PluginServiceRegistry>();
      final runtimeManager = context.read<PluginRuntimeManager>();
      unawaited(runtimeManager.resume(ProfilePluginRuntime.id));
      _controller = ProfileController(
        hostServices: services.get<ProfileHostServices>(),
        dataSourceActions: services.get<ProfileDataSourceActions>(),
        settingsActions: services.get<ProfileSettingsActions>(),
        runtimeCache: services.get<ProfileRuntimeCache>(),
        runtime: services.get<ProfilePluginRuntime>(),
      );
      unawaited(_controller.load());
    }
  }

  bool _isUninitialized = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final viewModel = _controller.viewModel;
        if (viewModel == null) {
          return const Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.green),
            ),
          );
        }

        return ProfileBody(
          viewModel: viewModel,
          onSettingsTap: () => context.push('/settings'),
          onSourceAction: _handleSourceAction,
          onSourceStrategyAction: _handleSourceStrategyAction,
          onSourceSecondaryAction: _handleSourceSecondaryAction,
          onTargetRangeTap: _editTargetRange,
        );
      },
    );
  }

  Future<void> _handleSourceAction(ProfileDataSourceViewModel source) async {
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
        if (source.kind == DataSourceKind.xdripLocal) {
          await _syncDataSource(source.kind);
        } else if (source.kind == DataSourceKind.nightscout) {
          await _syncDataSource(source.kind);
        }
        break;
      case DataSourceConnectionAction.use:
      case DataSourceConnectionAction.detect:
        break;
      case DataSourceConnectionAction.disconnect:
        await _disconnectDataSource(source.kind);
        break;
      case DataSourceConnectionAction.none:
        break;
    }
  }

  Future<void> _handleSourceStrategyAction(
    ProfileDataSourceViewModel source,
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
    ProfileDataSourceViewModel source,
  ) async {
    if (source.secondaryAction == DataSourceConnectionAction.configure &&
        source.kind == DataSourceKind.nightscout) {
      await _configureNightscout();
    }
  }

  Future<void> _connectXdripLocal() async {
    final messenger = ScaffoldMessenger.of(context);
    final message = await _controller.connectXdripLocal();
    if (!mounted) return;
    messenger.showSnackBar(_snack(message));
  }

  Future<void> _configureNightscout() async {
    final settings = _controller.currentSettings;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bgCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder:
          (ctx) => _NightscoutSetupSheet(
            initialUrl: settings.nightscoutBaseUrl ?? '',
            initialToken: settings.nightscoutToken ?? '',
            onTestAndConnect: _controller.connectNightscout,
          ),
    );
  }

  Future<void> _syncDataSource(DataSourceKind kind) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = switch (kind) {
      DataSourceKind.xdripLocal => await _controller.connectXdripLocal(),
      DataSourceKind.nightscout => await _controller.useConfiguredNightscout(),
    };
    if (!mounted) return;
    messenger.showSnackBar(_snack(message));
  }

  Future<void> _enableDataSourceSync(DataSourceKind kind) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = await _controller.enableDataSourceSync(kind);
    if (!mounted) return;
    messenger.showSnackBar(_snack(message));
  }

  Future<void> _disableDataSourceSync(DataSourceKind kind) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = await _controller.disableDataSourceSync(kind);
    if (!mounted) return;
    messenger.showSnackBar(_snack(message));
  }

  Future<void> _disconnectDataSource(DataSourceKind kind) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = await _controller.disconnectDataSource(kind);
    if (!mounted) return;
    messenger.showSnackBar(_snack(message));
  }

  Future<void> _editTargetRange() async {
    final messenger = ScaffoldMessenger.of(context);
    final settings = _controller.currentSettings;
    final draft = await showModalBottomSheet<TargetRangeDraft>(
      context: context,
      backgroundColor: AppColors.bgCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => TargetRangeRulerSheet(settings: settings),
    );
    if (draft == null) return;
    await _controller.updateTargetRange(draft);
    if (!mounted) return;
    messenger.showSnackBar(_snack('Target range updated'));
  }

  SnackBar _snack(String message) {
    return SnackBar(
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
    );
  }
}

class _NightscoutSetupSheet extends StatefulWidget {
  final String initialUrl;
  final String initialToken;
  final Future<DataSourceConnectionResult> Function({
    required String baseUrl,
    String? token,
  })
  onTestAndConnect;

  const _NightscoutSetupSheet({
    required this.initialUrl,
    required this.initialToken,
    required this.onTestAndConnect,
  });

  @override
  State<_NightscoutSetupSheet> createState() => _NightscoutSetupSheetState();
}

class _NightscoutSetupSheetState extends State<_NightscoutSetupSheet> {
  late final TextEditingController _urlController;
  late final TextEditingController _tokenController;
  bool _busy = false;
  String? _statusMessage;
  bool? _statusSuccess;

  bool get _isEditing => widget.initialUrl.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.initialUrl);
    _tokenController = TextEditingController(text: widget.initialToken);
    // Rebuild when URL field changes so clear button appears/disappears.
    _urlController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _urlController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderMid,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Text(
              _isEditing ? 'Update connection' : 'Nightscout API',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _isEditing
                  ? 'Update your site URL or access token below.'
                  : 'Enter your Nightscout site URL and optional access token.',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                height: 1.5,
                color: AppColors.textSoft,
              ),
            ),
            const SizedBox(height: 20),
            // URL field with clear button
            _UrlField(controller: _urlController),
            const SizedBox(height: 10),
            // Token field with show/hide
            _TokenField(controller: _tokenController),
            const SizedBox(height: 6),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Find your token in Nightscout > Admin Tools > Subjects',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: AppColors.textDim,
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Status area: fixed height to prevent layout jump.
            SizedBox(
              height: 48,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child:
                    _statusMessage != null
                        ? _ConnectionStatusRow(
                          key: ValueKey(_statusMessage),
                          message: _statusMessage!,
                          success: _statusSuccess,
                          busy: _busy,
                        )
                        : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 4),
            // Primary CTA
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: AppColors.green.withOpacity(0.35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  elevation: 0,
                ),
                onPressed: _busy ? null : _testAndConnect,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_busy) ...[
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      _busy ? 'Testing...' : 'Test and connect',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testAndConnect() async {
    final normalized = NightscoutUrlNormalizer.normalize(_urlController.text);
    if (normalized != null && normalized != _urlController.text.trim()) {
      _urlController.text = normalized;
    }
    final url = normalized ?? _urlController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _statusMessage = 'Enter a Nightscout URL to continue';
        _statusSuccess = false;
      });
      return;
    }
    setState(() {
      _busy = true;
      _statusMessage = 'Testing connection...';
      _statusSuccess = null;
    });
    final token = _tokenController.text.trim();
    final result = await widget.onTestAndConnect(
      baseUrl: url,
      token: token.isEmpty ? null : token,
    );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _statusMessage =
          result.success ? 'Connected, syncing now' : result.message;
      _statusSuccess = result.success;
    });
    if (result.success) {
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) Navigator.pop(context);
    }
  }
}

class _UrlField extends StatefulWidget {
  final TextEditingController controller;
  const _UrlField({required this.controller});

  @override
  State<_UrlField> createState() => _UrlFieldState();
}

class _UrlFieldState extends State<_UrlField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      autocorrect: false,
      onEditingComplete: _normalizeInput,
      style: const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 13,
        color: AppColors.text,
      ),
      decoration: InputDecoration(
        labelText: 'Site URL',
        hintText: 'https://your-site.herokuapp.com',
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          color: AppColors.textSoft,
        ),
        hintStyle: const TextStyle(color: AppColors.textDim),
        filled: true,
        fillColor: AppColors.bg,
        suffixIcon:
            widget.controller.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: AppColors.textDim,
                  ),
                  onPressed: widget.controller.clear,
                  splashRadius: 16,
                )
                : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.green),
        ),
      ),
    );
  }

  void _normalizeInput() {
    final normalized = NightscoutUrlNormalizer.normalize(
      widget.controller.text,
    );
    if (normalized != null && normalized != widget.controller.text.trim()) {
      widget.controller.text = normalized;
    }
    FocusScope.of(context).unfocus();
  }
}

class _TokenField extends StatefulWidget {
  final TextEditingController controller;
  const _TokenField({required this.controller});

  @override
  State<_TokenField> createState() => _TokenFieldState();
}

class _TokenFieldState extends State<_TokenField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      autocorrect: false,
      style: const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 13,
        color: AppColors.text,
      ),
      decoration: InputDecoration(
        labelText: 'Access token',
        hintText: 'Optional',
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          color: AppColors.textSoft,
        ),
        hintStyle: const TextStyle(color: AppColors.textDim),
        filled: true,
        fillColor: AppColors.bg,
        suffixIcon: IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 18,
            color: AppColors.textDim,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
          splashRadius: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.green),
        ),
      ),
    );
  }
}

class _ConnectionStatusRow extends StatelessWidget {
  final String message;
  final bool? success;
  final bool busy;

  const _ConnectionStatusRow({
    super.key,
    required this.message,
    required this.success,
    required this.busy,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        success == null
            ? AppColors.amber
            : success!
            ? AppColors.green
            : AppColors.rose;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.30)),
      ),
      child: Row(
        children: [
          if (busy)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.amber,
              ),
            )
          else
            Icon(
              success == true
                  ? Icons.check_circle_outline_rounded
                  : Icons.error_outline_rounded,
              size: 16,
              color: color,
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                height: 1.4,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
