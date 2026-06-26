class GeneratedWidget {
  final String type;
  final Map<String, dynamic> props;

  GeneratedWidget({
    required this.type,
    Map<String, dynamic>? props,
  }) : props = props ?? {};

  factory GeneratedWidget.fromJson(Map<String, dynamic> json) {
    return GeneratedWidget(
      type: json['type'] as String? ?? '',
      props: json['props'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'props': props,
    };
  }
}
