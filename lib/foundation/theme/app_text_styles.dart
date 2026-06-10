import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const _mono = TextStyle(fontFamily: 'JetBrainsMono');

  // Hero glucose value
  static final heroValue = _mono.copyWith(
    fontSize: 88,
    fontWeight: FontWeight.w700,
    color: AppColors.green,
    height: 1,
    letterSpacing: -2,
  );

  // Large metric number (32px)
  static final metricLarge = _mono.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  static final metricMedium = _mono.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1,
  );

  // Section label: MONO 10px uppercase
  static final sectionLabel = _mono.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textDim,
    letterSpacing: 1.6,
    height: 1,
  );

  // Eyebrow (9px)
  static final eyebrow = _mono.copyWith(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    color: AppColors.textDim,
    letterSpacing: 1.4,
  );

  // Body
  static const body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    color: AppColors.textSoft,
    height: 1.6,
  );

  static const bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const title = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -0.3,
  );

  // Mono data label
  static final monoData = _mono.copyWith(
    fontSize: 11,
    color: AppColors.textSoft,
  );

  static final monoDim = _mono.copyWith(fontSize: 10, color: AppColors.textDim);
}
