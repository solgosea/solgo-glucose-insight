import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension SafeNavigation on BuildContext {
  void safePopOrHome() {
    final router = GoRouter.of(this);
    if (router.canPop()) {
      router.pop();
      return;
    }
    router.go('/home');
  }
}
