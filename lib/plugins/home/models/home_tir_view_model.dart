import 'package:flutter/material.dart';

class HomeTirRowViewModel {
  final String label;
  final double percent;
  final Color color;

  const HomeTirRowViewModel({
    required this.label,
    required this.percent,
    required this.color,
  });
}

class HomeTirViewModel {
  final double tir;
  final double tar;
  final double tbr;
  final String footer;
  final List<HomeTirRowViewModel> rows;

  const HomeTirViewModel({
    required this.tir,
    required this.tar,
    required this.tbr,
    required this.footer,
    required this.rows,
  });
}
