import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

class HistoryNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool dim;

  const HistoryNavButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.dim,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: dim ? AppColors.border : AppColors.borderMid,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: dim ? AppColors.textDim : AppColors.text,
        ),
      ),
    );
  }
}
