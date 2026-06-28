import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';

class GlucoseChartMetricTileViewModel {
  final String label;
  final String value;
  final String helper;
  final Color valueColor;

  const GlucoseChartMetricTileViewModel({
    required this.label,
    required this.value,
    required this.helper,
    this.valueColor = AppColors.text,
  });
}
