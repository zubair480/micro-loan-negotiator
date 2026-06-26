import 'generated_widget.dart';

class GeneratedSurface {
  final String id;
  final String title;
  final String surfaceType;
  final List<GeneratedWidget> widgets;
  final Map<String, dynamic>? layout;

  GeneratedSurface({
    required this.id,
    required this.title,
    required this.surfaceType,
    required this.widgets,
    this.layout,
  });

  String get description {
    return 'Surface: $title ($surfaceType) with ${widgets.length} widgets';
  }

  factory GeneratedSurface.fromJson(Map<String, dynamic> json) {
    return GeneratedSurface(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      surfaceType: json['surface_type'] as String? ?? 'generated',
      widgets: (json['widgets'] as List<dynamic>?)
              ?.map((e) =>
                  GeneratedWidget.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      layout: json['layout'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'surface_type': surfaceType,
      'widgets': widgets.map((w) => w.toJson()).toList(),
      'layout': layout,
    };
  }
}
