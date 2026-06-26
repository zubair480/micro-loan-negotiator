class Recommendation {
  final String id;
  final String title;
  final String description;
  final String type;
  final double confidence;
  final List<String> actionItems;
  final String reasoning;
  final bool isActionRequired;

  Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.confidence,
    required this.actionItems,
    required this.reasoning,
    required this.isActionRequired,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'info',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      actionItems: (json['action_items'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      reasoning: json['reasoning'] as String? ?? '',
      isActionRequired: json['is_action_required'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'confidence': confidence,
      'action_items': actionItems,
      'reasoning': reasoning,
      'is_action_required': isActionRequired,
    };
  }
}
