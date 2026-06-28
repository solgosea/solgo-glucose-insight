import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';

class JugglucoNoticeCard extends StatelessWidget {
  const JugglucoNoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.blue.withOpacity(.055),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: StatusMonitorTheme.blue.withOpacity(.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: StatusMonitorTheme.blue.withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: StatusMonitorTheme.blue.withOpacity(.24)),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: StatusMonitorTheme.blue,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What this page can prove',
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                _NoticeLine(
                  text:
                      'It observes broadcasts received by SolgoInsight on this phone.',
                ),
                _NoticeLine(
                  text:
                      'It helps locate delay between Juggluco, xDrip+, and Nightscout.',
                ),
                _NoticeLine(
                  text:
                      'It does not diagnose Juggluco internals, Libre firmware, OOP2, or treatment decisions.',
                  last: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeLine extends StatelessWidget {
  final String text;
  final bool last;

  const _NoticeLine({required this.text, this.last = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: StatusMonitorTheme.blue.withOpacity(.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: StatusMonitorTheme.inter.copyWith(
                color: StatusMonitorTheme.soft,
                fontSize: 11.2,
                height: 1.42,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
