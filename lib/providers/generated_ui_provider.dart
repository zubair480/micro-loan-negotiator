import 'package:flutter/foundation.dart';
import '../models/generated_surface.dart';
import '../models/generated_widget.dart';

class GeneratedUIProvider extends ChangeNotifier {
  GeneratedSurface? _currentSurface;
  final List<GeneratedSurface> _surfaceHistory = [];
  bool _isTransitioning = false;

  GeneratedSurface? get currentSurface => _currentSurface;
  List<GeneratedSurface> get surfaceHistory =>
      List.unmodifiable(_surfaceHistory);
  bool get isTransitioning => _isTransitioning;

  void setSurface(GeneratedSurface surface) {
    _currentSurface = surface;
    _surfaceHistory.add(surface);
    notifyListeners();
  }

  void updateWidgetProps(String widgetType, Map<String, dynamic> newProps) {
    if (_currentSurface == null) return;
    final updatedWidgets = _currentSurface!.widgets.map((w) {
      if (w.type == widgetType) {
        return GeneratedWidget(type: w.type, props: newProps);
      }
      return w;
    }).toList();
    _currentSurface = GeneratedSurface(
      id: _currentSurface!.id,
      title: _currentSurface!.title,
      surfaceType: _currentSurface!.surfaceType,
      widgets: updatedWidgets,
      layout: _currentSurface!.layout,
    );
    notifyListeners();
  }

  void setTransitioning(bool value) {
    _isTransitioning = value;
    notifyListeners();
  }

  void clear() {
    _currentSurface = null;
    _surfaceHistory.clear();
    _isTransitioning = false;
    notifyListeners();
  }
}
