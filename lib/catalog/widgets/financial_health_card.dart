import 'package:flutter/material.dart';

class FinancialHealthCard extends StatefulWidget {
  final Map<String, dynamic> props;

  const FinancialHealthCard({super.key, required this.props});

  @override
  State<FinancialHealthCard> createState() => _FinancialHealthCardState();
}

class _FinancialHealthCardState extends State<FinancialHealthCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
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
    final score = (widget.props['health_score'] as num?)?.toDouble() ?? 0;
    final metrics =
        (widget.props['metrics'] as Map<String, dynamic>?) ?? {};

    final color = score >= 80
        ? Colors.green
        : score >= 60
            ? Colors.blue
            : score >= 40
                ? Colors.orange
                : Colors.red;

    final label = score >= 80
        ? 'Excellent'
        : score >= 60
            ? 'Good'
            : score >= 40
                ? 'Fair'
                : 'Needs Work';

    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
      axisAlignment: -1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.pink),
                  const SizedBox(width: 12),
                  Text(
                    'Financial Health',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      '$score',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: color),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...metrics.entries.map((entry) {
                final value =
                    (entry.value as num?)?.toDouble() ?? 0;
                final metricColor = _metricColor(entry.key, value);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _metricLabel(entry.key),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                          ),
                          Text(
                            _metricValue(entry.key, value),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: metricColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _metricProgress(entry.key, value)
                              .clamp(0, 1),
                          backgroundColor:
                              Colors.grey.withValues(alpha: 0.2),
                          valueColor:
                              AlwaysStoppedAnimation(metricColor),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Color _metricColor(String key, double value) {
    switch (key) {
      case 'credit_score':
        return value >= 740 ? Colors.green : value >= 670 ? Colors.orange : Colors.red;
      case 'savings_ratio':
        return value >= 0.2 ? Colors.green : value >= 0.1 ? Colors.orange : Colors.red;
      case 'dti':
        return value < 0.36 ? Colors.green : value < 0.43 ? Colors.orange : Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _metricLabel(String key) {
    switch (key) {
      case 'credit_score':
        return 'Credit Score';
      case 'savings_ratio':
        return 'Savings Ratio';
      case 'dti':
        return 'Debt-to-Income';
      case 'income_stability':
        return 'Income Stability';
      default:
        return key;
    }
  }

  String _metricValue(String key, double value) {
    switch (key) {
      case 'credit_score':
        return '${value.toInt()}';
      case 'savings_ratio':
        return '${(value * 100).toStringAsFixed(0)}%';
      case 'dti':
        return '${(value * 100).toStringAsFixed(1)}%';
      case 'income_stability':
        return '${(value * 100).toStringAsFixed(0)}%';
      default:
        return value.toString();
    }
  }

  double _metricProgress(String key, double value) {
    switch (key) {
      case 'credit_score':
        return (value - 300) / 550;
      case 'savings_ratio':
        return value / 0.5;
      case 'dti':
        return 1 - (value / 0.5);
      case 'income_stability':
        return value;
      default:
        return value;
    }
  }
}
