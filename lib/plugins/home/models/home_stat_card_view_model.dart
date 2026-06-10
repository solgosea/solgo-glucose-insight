import 'package:flutter/material.dart';

class HomeStatCardViewModel {
  final String label;
  final String value;
  final String unit;
  final Color valueColor;

  const HomeStatCardViewModel({
    required this.label,
    required this.value,
    required this.unit,
    required this.valueColor,
  });
}
