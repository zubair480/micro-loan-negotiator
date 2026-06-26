import 'package:flutter/material.dart';

class ConfidenceCard extends StatefulWidget {
  final Map<String, dynamic> props;

  const ConfidenceCard({super.key, required this.props});

  @override
  State<ConfidenceCard> createState() => _ConfidenceCardState();
}

class _ConfidenceCardState extends State<ConfidenceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final score = (widget.props['score'] as num?)?.toDouble() ?? 0;
    final label = (widget.props['label'] as String?) ?? 'Approval Confidence';
    final maxScore = (widget.props['max_score'] as num?)?.toDouble() ?? 100;

    final normalized = ((score / maxScore).clamp(0, 1)).toDouble();
    final color = normalized >= 0.7
        ? Colors.green
        : normalized >= 0.4
            ? Colors.orange
            : Colors.red;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: normalized * _animation.value,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(score * _animation.value).toInt()}',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(color: color),
                          ),
                          Text(
                            '/ ${maxScore.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    _confidenceLabel(normalized),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: color),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _confidenceLabel(double value) {
    if (value >= 0.9) return 'Very High Confidence';
    if (value >= 0.7) return 'High Confidence';
    if (value >= 0.4) return 'Moderate Confidence';
    if (value >= 0.2) return 'Low Confidence';
    return 'Very Low Confidence';
  }
}
