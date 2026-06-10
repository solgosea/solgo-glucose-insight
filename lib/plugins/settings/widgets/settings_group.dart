import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

class SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const SettingsGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var index = 0; index < children.length; index++) {
      rows.add(children[index]);
      if (index != children.length - 1) {
        rows.add(
          const Divider(color: AppColors.border, height: 1, thickness: 1),
        );
      }
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: rows),
    );
  }
}
