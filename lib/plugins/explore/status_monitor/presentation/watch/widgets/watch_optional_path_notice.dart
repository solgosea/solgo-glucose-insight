import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';

class WatchOptionalPathNotice extends StatelessWidget {
  const WatchOptionalPathNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.blue.withOpacity(.065),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: StatusMonitorTheme.blue.withOpacity(.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: StatusMonitorTheme.blue.withOpacity(.10),
              borderRadius: BorderRadius.circular(13),
              border:
                  Border.all(color: StatusMonitorTheme.blue.withOpacity(.28)),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: StatusMonitorTheme.blue,
              size: 19,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Optional path, not core CGM health',
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'A missing watch signal does not mean CGM, xDrip+, Nightscout, or AAPS is broken. It only means the wearable display path is not currently confirmed.',
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.soft,
                    fontSize: 11.2,
                    height: 1.42,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
