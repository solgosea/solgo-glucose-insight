import 'package:flutter/material.dart';

import '../../../domain/hub/status_hub_enums.dart';
import '../models/status_hub_view_model.dart';
import 'status_hub_observer_note.dart';
import 'scoring/status_hub_score_legend.dart';
import 'status_hub_topology_chips.dart';
import 'status_hub_topology_nodes.dart';
import 'status_hub_topology_painter.dart';
import 'status_hub_visuals.dart';
import '../../styles/status_monitor_theme.dart';

class StatusHubConnectionMapSection extends StatelessWidget {
  final StatusHubViewModel viewModel;

  const StatusHubConnectionMapSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final nodes = {for (final node in viewModel.nodes) node.id: node};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatusHubSectionTitle(
          title: viewModel.topology.title,
          trailing: viewModel.evidence.ratioLabel,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: StatusMonitorTheme.glassCardDecoration(elevated: true),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MapHeader(viewModel: viewModel),
                const SizedBox(height: 10),
                _TopologyCanvas(nodes: nodes, viewModel: viewModel),
                const SizedBox(height: 10),
                const StatusHubScoreLegend(),
                const SizedBox(height: 10),
                StatusHubObserverNote(viewModel: viewModel),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MapHeader extends StatelessWidget {
  final StatusHubViewModel viewModel;

  const _MapHeader({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            viewModel.topology.subtitle,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 11,
              height: 1.32,
            ),
          ),
        ),
        const SizedBox(width: 10),
        StatusHubPill(
          label: viewModel.topology.badgeLabel,
          state: viewModel.summary.state,
        ),
      ],
    );
  }
}

class _TopologyCanvas extends StatefulWidget {
  final Map<StatusHubNodeId, StatusHubNodeViewModel> nodes;
  final StatusHubViewModel viewModel;

  const _TopologyCanvas({
    required this.nodes,
    required this.viewModel,
  });

  @override
  State<_TopologyCanvas> createState() => _TopologyCanvasState();
}

class _TopologyCanvasState extends State<_TopologyCanvas>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Honor reduced-motion: hold the flow dashes static.
    final animate = !MediaQuery.of(context).disableAnimations;
    return AspectRatio(
      // Matches the HTML viewBox 340 x 360.
      aspectRatio: 340 / 360,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: StatusHubTopologyPainter(
                        connections: widget.viewModel.connections,
                        dashPhase: animate ? _controller.value : 0,
                      ),
                    );
                  },
                ),
              ),
              // Outer nodes — rects in HTML viewBox (340 x 360).
              _node(
                  size,
                  11,
                  121,
                  86,
                  58,
                  StatusHubOuterNode(
                      node: widget.nodes[StatusHubNodeId.cgmSensor]!)),
              _node(
                  size,
                  243,
                  121,
                  86,
                  58,
                  StatusHubOuterNode(
                      node: widget.nodes[StatusHubNodeId.juggluco]!)),
              _node(
                  size,
                  127,
                  37,
                  86,
                  58,
                  StatusHubOuterNode(
                      node: widget.nodes[StatusHubNodeId.nightscout]!)),
              _node(
                  size,
                  198,
                  257,
                  86,
                  58,
                  StatusHubOuterNode(
                      node: widget.nodes[StatusHubNodeId.aaps]!, muted: true)),
              _node(
                  size,
                  56,
                  257,
                  86,
                  58,
                  StatusHubOuterNode(
                      node: widget.nodes[StatusHubNodeId.watch]!, muted: true)),
              // Center hub — 92 x 88 at (124,141).
              _node(
                  size,
                  124,
                  141,
                  92,
                  88,
                  StatusHubCenterNode(
                      node: widget.nodes[StatusHubNodeId.xdrip]!)),
              // Freshness chips — placed beside each spoke via shared geometry.
              _chip(size, StatusHubConnectionId.cgmToXdrip),
              _chip(size, StatusHubConnectionId.jugglucoToXdrip),
              _chip(size, StatusHubConnectionId.xdripToNightscout),
              _chip(size, StatusHubConnectionId.xdripToAaps),
              _chip(size, StatusHubConnectionId.xdripToWatch),
            ],
          );
        },
      ),
    );
  }

  StatusHubPositionedMapNode _node(
    Size size,
    double x,
    double y,
    double w,
    double h,
    Widget child,
  ) {
    return StatusHubPositionedMapNode(
      size: size,
      left: x / 340,
      top: y / 360,
      width: w / 340,
      height: h / 360,
      child: child,
    );
  }

  StatusHubConnectionChip _chip(
    Size size,
    StatusHubConnectionId id,
  ) {
    const chipW = 34.0;
    const chipH = 17.0;
    // Geometry returns the chip CENTER (normalized); convert to top-left.
    final center = StatusHubMapGeometry.chipCenterFor(id);
    return StatusHubConnectionChip(
      size: size,
      left: center.dx - (chipW / 2) / 340,
      top: center.dy - (chipH / 2) / 360,
      width: chipW / 340,
      height: chipH / 360,
      connection:
          widget.viewModel.connections.firstWhere((item) => item.id == id),
    );
  }
}
