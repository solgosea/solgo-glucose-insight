import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../styles/status_monitor_theme.dart';
import 'status_setup_prompt_model.dart';

class StatusSetupPromptBar extends StatelessWidget {
  final StatusSetupPromptModel model;

  const StatusSetupPromptBar({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.go('/profile'),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: StatusMonitorTheme.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: model.accentColor.withOpacity(.30)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 18,
                offset: Offset(0, 9),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 320;
              final iconSize = compact ? 38.0 : 42.0;
              return Wrap(
                spacing: compact ? 9 : 12,
                runSpacing: compact ? 10 : 0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: model.accentColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: model.accentColor.withOpacity(.26),
                      ),
                    ),
                    child: Icon(
                      model.icon,
                      color: model.accentColor,
                      size: compact ? 21 : 23,
                    ),
                  ),
                  SizedBox(
                    width: math.max(
                      0,
                      constraints.maxWidth -
                          iconSize -
                          (compact ? 9 : 12) -
                          (compact ? 0 : 108),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: StatusMonitorTheme.inter.copyWith(
                            color: StatusMonitorTheme.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          model.body,
                          maxLines: compact ? 3 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: StatusMonitorTheme.inter.copyWith(
                            color: StatusMonitorTheme.soft,
                            fontSize: 11.8,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: StatusMonitorTheme.green,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      model.actionLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StatusMonitorTheme.inter.copyWith(
                        color: StatusMonitorTheme.bg,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
