import 'package:flutter/material.dart';

import '../../domain/status_level.dart';

class StatusMonitorTheme {
  static const bg = Color(0xFF07110E);
  static const card = Color(0xFF111C18);
  static const card2 = Color(0xFF16231F);
  static const text = Color(0xFFEAF6EF);
  static const soft = Color(0xFF9DB6AA);
  static const dim = Color(0xFF6E8578);
  static const green = Color(0xFF6EE69E);
  static const green2 = Color(0xFF35C986);
  static const amber = Color(0xFFF0B44E);
  static const rose = Color(0xFFF07876);
  static const blue = Color(0xFF72B7F8);
  static const teal = Color(0xFF46D6C9);
  static const muted = Color(0xFF52675E);
  static const border = Color(0x2639D98A);
  static const line = Color(0x2976E8A4);

  static const mono = TextStyle(fontFamily: 'JetBrains Mono');
  static const inter = TextStyle(fontFamily: 'Inter');

  static Color colorFor(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => green,
      StatusLevel.watch => amber,
      StatusLevel.issue => rose,
      StatusLevel.unknown => dim,
    };
  }

  static BoxDecoration cardDecoration({
    StatusLevel? level,
    bool elevated = false,
  }) {
    final color = level == null ? border : colorFor(level).withOpacity(.30);
    return BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color),
      boxShadow: elevated
          ? const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 22,
                offset: Offset(0, 10),
              ),
            ]
          : null,
    );
  }

  static BoxDecoration glassCardDecoration({
    StatusLevel? level,
    bool elevated = false,
  }) {
    final color = level == null ? line : colorFor(level).withOpacity(.30);
    return BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x0AFFFFFF),
          Color(0x04FFFFFF),
        ],
      ),
      boxShadow: elevated
          ? const [
              BoxShadow(
                color: Color(0x4D000000),
                blurRadius: 28,
                offset: Offset(0, 12),
              ),
            ]
          : null,
    );
  }

  static BoxDecoration pageBackground() {
    return const BoxDecoration(
      gradient: RadialGradient(
        center: Alignment(-0.75, -1),
        radius: 1.1,
        colors: [
          Color(0x2472E79F),
          Color(0x0007110E),
        ],
      ),
    );
  }
}
