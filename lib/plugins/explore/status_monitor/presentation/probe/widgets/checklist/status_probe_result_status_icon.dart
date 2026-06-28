import 'package:flutter/material.dart';

class StatusProbeResultStatusIcon {
  static IconData forCode(String code) {
    return switch (code) {
      'PKG' => Icons.phone_android_rounded,
      'BG' => Icons.sensors_rounded,
      'AGE' => Icons.schedule_rounded,
      'API' => Icons.cloud_queue_rounded,
      'SRC' => Icons.account_tree_rounded,
      'NET' => Icons.wifi_rounded,
      'BT' => Icons.bluetooth_rounded,
      'PERM' => Icons.verified_user_rounded,
      'PWR' => Icons.battery_charging_full_rounded,
      'RUN' => Icons.sync_rounded,
      _ => Icons.fact_check_rounded,
    };
  }
}
