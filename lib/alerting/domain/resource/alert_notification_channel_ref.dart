class AlertNotificationChannelRef {
  final String id;
  final String name;
  final String description;

  const AlertNotificationChannelRef({
    required this.id,
    required this.name,
    required this.description,
  });

  const AlertNotificationChannelRef.critical()
    : id = 'smartxdrip_critical_alerts',
      name = 'Critical glucose alerts',
      description = 'Urgent glucose safety alerts.';

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };

  static AlertNotificationChannelRef fromJson(Map<String, Object?> json) {
    return AlertNotificationChannelRef(
      id: json['id'] as String? ?? 'smartxdrip_critical_alerts',
      name: json['name'] as String? ?? 'Critical glucose alerts',
      description:
          json['description'] as String? ?? 'Urgent glucose safety alerts.',
    );
  }
}
