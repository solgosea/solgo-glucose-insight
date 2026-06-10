import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../foundation/theme/app_colors.dart';
import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../navigation/android_back_to_background_host.dart';

class BottomNavShell extends StatelessWidget {
  final StatefulNavigationShell shell;
  final List<MainTabPluginEntry> tabs;

  const BottomNavShell({super.key, required this.shell, required this.tabs});

  @override
  Widget build(BuildContext context) {
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
            fontFamily: 'JetBrainsMono',
            fontSize: 9,
            letterSpacing: 0.8,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 9,
            letterSpacing: 0.8,
          ),
          elevation: 0,
          items: [
            for (final tab in tabs)
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
