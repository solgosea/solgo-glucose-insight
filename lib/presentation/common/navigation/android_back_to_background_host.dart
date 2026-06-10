import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../infrastructure/platform/android_task_backgrounder.dart';

class AndroidBackToBackgroundHost extends StatelessWidget {
  final Widget child;
  final AndroidTaskBackgrounder backgrounder;

  const AndroidBackToBackgroundHost({
    super.key,
    required this.child,
    this.backgrounder = const AndroidTaskBackgrounder(),
  });

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        final router = GoRouter.of(context);
        if (router.canPop()) {
          router.pop();
          return true;
        }
        final moved = await backgrounder.moveTaskToBack();
        return moved;
      },
      child: child,
    );
  }
}
