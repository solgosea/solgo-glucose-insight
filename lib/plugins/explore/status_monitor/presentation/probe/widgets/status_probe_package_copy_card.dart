import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusProbePackageCopyCard extends StatelessWidget {
  final String packageName;

  const StatusProbePackageCopyCard({
    super.key,
    this.packageName = 'com.metaguru.smartxdrip',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Receiver package'),
        subtitle: Text(packageName),
        trailing: IconButton(
          icon: const Icon(Icons.copy_rounded),
          onPressed: () => Clipboard.setData(ClipboardData(text: packageName)),
        ),
      ),
    );
  }
}
