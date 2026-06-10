import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

class HistoryPageTitle extends StatelessWidget {
  const HistoryPageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(
        'History',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}
