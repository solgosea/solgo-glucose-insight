import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('Usage: dart run tool/gen_plugin_l10n.dart <plugin_name>');
    exitCode = 64;
    return;
  }

  final pluginArg = args.single.replaceAll('\\', '/');
  final pluginName = pluginArg.split('/').last;
  final explicitPluginDir = Directory('lib/plugins/$pluginArg');
  final explorePluginDir = Directory('lib/plugins/explore/$pluginName');
  final rootPluginDir = Directory('lib/plugins/$pluginName');
  final hostDir = Directory('lib/$pluginArg');
  final pluginDir = pluginArg.contains('/')
      ? explicitPluginDir
      : explorePluginDir.existsSync()
          ? explorePluginDir
          : rootPluginDir.existsSync()
              ? rootPluginDir
              : hostDir;
  final arbDir = Directory('${pluginDir.path}/l10n');
  if (!arbDir.existsSync()) {
    stderr.writeln('No l10n directory found for plugin: $pluginArg');
    exitCode = 66;
    return;
  }

  final className = pluginName
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join();
  final outputClass = '${className}Localizations';
  final outputFile = '${pluginName}_localizations.dart';
  final templateFile = '${pluginName}_en.arb';
  final outputDir = '${arbDir.path}/generated';

  final rootConfig = File('l10n.yaml');
  final parkedConfig = File('l10n.yaml.plugin-gen-backup');
  if (parkedConfig.existsSync()) {
    stderr.writeln(
        'Refusing to run because ${parkedConfig.path} already exists.');
    exitCode = 73;
    return;
  }

  try {
    if (rootConfig.existsSync()) {
      rootConfig.renameSync(parkedConfig.path);
    }
    final result = await Process.start(
      'flutter',
      [
        'gen-l10n',
        '--arb-dir=${arbDir.path}',
        '--template-arb-file=$templateFile',
        '--output-localization-file=$outputFile',
        '--output-class=$outputClass',
        '--output-dir=$outputDir',
        '--no-synthetic-package',
        '--no-nullable-getter',
        '--no-use-deferred-loading',
      ],
      mode: ProcessStartMode.inheritStdio,
      runInShell: true,
    );
    exitCode = await result.exitCode;
  } finally {
    if (parkedConfig.existsSync()) {
      parkedConfig.renameSync(rootConfig.path);
    }
  }
}
