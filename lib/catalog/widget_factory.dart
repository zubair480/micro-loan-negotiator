import 'package:flutter/material.dart';
import '../models/generated_surface.dart';
import 'widget_registry.dart';

class WidgetFactory extends StatelessWidget {
  final GeneratedSurface surface;
  final AnimationController? animationController;

  const WidgetFactory({
    super.key,
    required this.surface,
    this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final widgets = surface.widgets;
    if (widgets.isEmpty) {
      return const Center(child: Text('No widgets to display'));
    }

    return AnimatedBuilder(
      animation: animationController ?? AlwaysStoppedAnimation(1),
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              ...List.generate(widgets.length, (index) {
                return _buildAnimatedWidget(index, context);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        surface.title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  Widget _buildAnimatedWidget(int index, BuildContext context) {
    final widget = surface.widgets[index];
    final delay = index * 100;
    return _AnimatedWidgetEntry(
      index: index,
      delay: delay,
      animationController: animationController,
      child: WidgetRegistry.build(widget.type, widget.props),
    );
  }
}

class _AnimatedWidgetEntry extends StatefulWidget {
  final int index;
  final int delay;
  final AnimationController? animationController;
  final Widget child;

  const _AnimatedWidgetEntry({
    required this.index,
    required this.delay,
    this.animationController,
    required this.child,
  });

  @override
  State<_AnimatedWidgetEntry> createState() => _AnimatedWidgetEntryState();
}

class _AnimatedWidgetEntryState extends State<_AnimatedWidgetEntry>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: widget.child,
        ),
      ),
    );
  }
}
