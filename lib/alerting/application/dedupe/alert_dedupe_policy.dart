import '../../domain/queue/alert_queue_message.dart';
import '../../domain/queue/alert_queue_message_state.dart';
import 'alert_dedupe_resolution.dart';

class AlertDedupePolicy {
  const AlertDedupePolicy();

  AlertDedupeResolution resolve({
    required AlertQueueMessage incoming,
    required AlertQueueMessage? existing,
  }) {
    if (existing == null) return const AlertDedupeResolution.enqueue();
    if (existing.state == AlertQueueMessageState.processed) {
      return const AlertDedupeResolution.suppress('already_processed');
    }
    final incomingPriority = _sourcePriority(incoming);
    final existingPriority = _sourcePriority(existing);
    if (incomingPriority > existingPriority) {
      return const AlertDedupeResolution.replaceExisting();
    }
    return const AlertDedupeResolution.suppress('lower_or_equal_priority');
  }

  int _sourcePriority(AlertQueueMessage message) {
    return message.sourcePriority;
  }
}
