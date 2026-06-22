import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/data_source/data_source_connection_result.dart';
import 'package:smart_xdrip/application/nightscout/nightscout_url_normalizer.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../application/i18n/datasource_l10n.dart';

class NightscoutSetupSheet extends StatefulWidget {
  final String initialUrl;
  final String initialToken;
  final Future<DataSourceConnectionResult> Function({
    required String baseUrl,
    String? token,
  }) onTestAndConnect;

  const NightscoutSetupSheet({
    super.key,
    required this.initialUrl,
    required this.initialToken,
    required this.onTestAndConnect,
  });

  @override
  State<NightscoutSetupSheet> createState() => _NightscoutSetupSheetState();
}

class _NightscoutSetupSheetState extends State<NightscoutSetupSheet> {
  late final TextEditingController _urlController;
  late final TextEditingController _tokenController;
  bool _busy = false;
  String? _statusMessage;
  bool? _statusSuccess;
  bool _obscureToken = true;

  bool get _isEditing => widget.initialUrl.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.initialUrl);
    _tokenController = TextEditingController(text: widget.initialToken);
    _urlController.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _urlController
      ..removeListener(_rebuild)
      ..dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.datasourceL10n;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            Text(
              _isEditing
                  ? l10n.nightscoutUpdateConnection
                  : l10n.nightscoutApiTitle,
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
                  ? l10n.nightscoutUpdateSubtitle
                  : l10n.nightscoutSetupSubtitle,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                height: 1.5,
                color: AppColors.textSoft,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _urlController,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              autocorrect: false,
              onEditingComplete: _normalizeInput,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 13,
                color: AppColors.text,
              ),
              decoration: _inputDecoration(
                label: l10n.nightscoutSiteUrl,
                hint: l10n.nightscoutUrlHint,
                suffixIcon: _urlController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: AppColors.textDim,
                        ),
                        onPressed: _urlController.clear,
                        splashRadius: 16,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tokenController,
              obscureText: _obscureToken,
              autocorrect: false,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 13,
                color: AppColors.text,
              ),
              decoration: _inputDecoration(
                label: l10n.nightscoutAccessToken,
                hint: l10n.nightscoutOptional,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureToken
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                    color: AppColors.textDim,
                  ),
                  onPressed: () => setState(() {
                    _obscureToken = !_obscureToken;
                  }),
                  splashRadius: 18,
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 48,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _statusMessage != null
                    ? _StatusRow(
                        key: ValueKey(_statusMessage),
                        message: _statusMessage!,
                        success: _statusSuccess,
                        busy: _busy,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 4),
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
                child: Text(
                  _busy
                      ? l10n.nightscoutTesting
                      : l10n.nightscoutTestAndConnect,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(
        fontFamily: 'Inter',
        color: AppColors.textSoft,
      ),
      hintStyle: const TextStyle(color: AppColors.textDim),
      filled: true,
      fillColor: AppColors.bg,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.green),
      ),
    );
  }

  void _normalizeInput() {
    final normalized = NightscoutUrlNormalizer.normalize(_urlController.text);
    if (normalized != null && normalized != _urlController.text.trim()) {
      _urlController.text = normalized;
    }
    FocusScope.of(context).unfocus();
  }

  Future<void> _testAndConnect() async {
    final normalized = NightscoutUrlNormalizer.normalize(_urlController.text);
    if (normalized != null && normalized != _urlController.text.trim()) {
      _urlController.text = normalized;
    }
    final url = normalized ?? _urlController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _statusMessage = context.datasourceL10n.nightscoutEnterUrl;
        _statusSuccess = false;
      });
      return;
    }
    setState(() {
      _busy = true;
      _statusMessage = context.datasourceL10n.nightscoutTestingConnection;
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
      _statusMessage = result.success
          ? context.datasourceL10n.nightscoutConnectedSyncing
          : result.message;
      _statusSuccess = result.success;
    });
    if (result.success) {
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) Navigator.pop(context);
    }
  }
}

class _StatusRow extends StatelessWidget {
  final String message;
  final bool? success;
  final bool busy;

  const _StatusRow({
    super.key,
    required this.message,
    required this.success,
    required this.busy,
  });

  @override
  Widget build(BuildContext context) {
    final color = success == null
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
