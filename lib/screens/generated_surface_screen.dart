import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/generated_ui_provider.dart';
import '../catalog/widget_factory.dart';

class GeneratedSurfaceScreen extends StatefulWidget {
  const GeneratedSurfaceScreen({super.key});

  @override
  State<GeneratedSurfaceScreen> createState() =>
      _GeneratedSurfaceScreenState();
}

class _GeneratedSurfaceScreenState extends State<GeneratedSurfaceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Personalized View'),
        actions: [
          Consumer<GeneratedUIProvider>(
            builder: (context, provider, child) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'offer_details':
                      Navigator.of(context).pushNamed('/offer_details');
                    case 'negotiation':
                      Navigator.of(context).pushNamed('/negotiation');
                    case 'summary':
                      Navigator.of(context).pushNamed('/summary');
                    case 'refresh':
                      _refreshSurface();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'offer_details',
                    child: ListTile(
                      leading: Icon(Icons.description),
                      title: Text('Offer Details'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'negotiation',
                    child: ListTile(
                      leading: Icon(Icons.handshake),
                      title: Text('Negotiation'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'summary',
                    child: ListTile(
                      leading: Icon(Icons.summarize),
                      title: Text('Summary'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'refresh',
                    child: ListTile(
                      leading: Icon(Icons.refresh),
                      title: Text('Regenerate'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<GeneratedUIProvider>(
        builder: (context, provider, child) {
          final surface = provider.currentSurface;
          if (surface == null) {
            return const Center(
              child: Text('No generated surface available'),
            );
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: WidgetFactory(
              key: ValueKey(surface.id),
              surface: surface,
              animationController: _controller,
            ),
          );
        },
      ),
    );
  }

  void _refreshSurface() {
    _controller.reset();
    _controller.forward();
    context.read<GeneratedUIProvider>().setTransitioning(true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        context.read<GeneratedUIProvider>().setTransitioning(false);
      }
    });
  }
}
