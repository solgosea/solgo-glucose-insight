import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const bg = Color(0xFF0C1410);
  static const bgCard = Color(0xFF131F1A);
  static const bgCard2 = Color(0xFF182620);

  // Borders
  static const border = Color(0x246EE89E); // rgba(110,230,160,.14)
  static const borderMid = Color(0x476EE89E); // rgba(110,230,160,.28)

  // Text
  static const text = Color(0xFFD6EDE3);
  static const textSoft = Color(0xFF8FBFAA);
  static const textDim = Color(0xFF4D7264);

  // Accent
  static const green = Color(0xFF6EE89E);
  static const amber = Color(0xFFF0B44E);
  static const rose = Color(0xFFF07876);
  static const blue = Color(0xFF5DB8F0);

  // Semantic glucose states
  static Color glucoseColor(double value, double low, double high) {
    if (value < low) return blue;
    if (value > high) return rose;
    return green;
  }
}
