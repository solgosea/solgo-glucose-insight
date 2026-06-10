import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../models/history_view_model.dart';
import 'history_event_row.dart';

class HistoryEventsList extends StatelessWidget {
  final List<HistoryEventRowViewModel> events;

  const HistoryEventsList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'No events recorded',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: AppColors.textDim,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (var i = 0; i < events.length; i++)
            HistoryEventRow(
              viewModel: events[i],
              isLast: i == events.length - 1,
            ),
        ],
      ),
    );
  }
}
