import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../styles/status_monitor_theme.dart';

class StatusCopyableCodeRow extends StatefulWidget {
  final String label;
  final String value;
  final String copiedMessage;
  final IconData icon;

  const StatusCopyableCodeRow({
    super.key,
    required this.label,
    required this.value,
    this.copiedMessage = 'Copied package name',
    this.icon = Icons.content_copy_rounded,
  });

  @override
  State<StatusCopyableCodeRow> createState() => _StatusCopyableCodeRowState();
}

class _StatusCopyableCodeRowState extends State<StatusCopyableCodeRow> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.value));
    if (!mounted) return;
    setState(() => _copied = true);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(widget.copiedMessage),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1400),
        ),
      );
    Future<void>.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = _copied ? StatusMonitorTheme.green : StatusMonitorTheme.blue;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _copy,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(_copied ? .13 : .095),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(.46), width: 1.15),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(.10),
                blurRadius: 18,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withOpacity(.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(.26)),
                ),
                child: Icon(
                  _copied ? Icons.check_rounded : widget.icon,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: StatusMonitorTheme.inter.copyWith(
                        color: color,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.18),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: color.withOpacity(.28)),
                      ),
                      child: Text(
                        widget.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: StatusMonitorTheme.mono.copyWith(
                          color: StatusMonitorTheme.text,
                          fontSize: 12.2,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withOpacity(.20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(.32)),
                ),
                child: Icon(
                  _copied ? Icons.check_circle_rounded : Icons.copy_rounded,
                  color: color,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
