import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../foundation/theme/app_colors.dart';
import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../../../plugin_platform/i18n/plugin_entry_localization_registry.dart';
import '../navigation/android_back_to_background_host.dart';

class BottomNavShell extends StatelessWidget {
  final StatefulNavigationShell shell;
  final List<MainTabPluginEntry> tabs;
  final PluginEntryLocalizationRegistry? entryLocalizers;

  const BottomNavShell({
    super.key,
    required this.shell,
    required this.tabs,
    this.entryLocalizers,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return AndroidBackToBackgroundHost(
      child: Scaffold(
        body: HeroControllerScope.none(child: shell),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: shell.currentIndex,
          onTap: shell.goBranch,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xF7122018),
          selectedItemColor: AppColors.green,
          unselectedItemColor: AppColors.textDim,
          selectedLabelStyle: const TextStyle(
              fontFamily: 'JetBrainsMono', fontSize: 9, letterSpacing: 0.8),
          unselectedLabelStyle: const TextStyle(
              fontFamily: 'JetBrainsMono', fontSize: 9, letterSpacing: 0.8),
          elevation: 0,
          items: [
            for (final rawTab in tabs)
              for (final tab in [
                entryLocalizers?.localizeMainTab(rawTab, locale) ?? rawTab,
              ])
                BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  activeIcon: Icon(tab.activeIcon),
                  label: tab.label,
                ),
          ],
        ),
      ),
    );
  }
}
